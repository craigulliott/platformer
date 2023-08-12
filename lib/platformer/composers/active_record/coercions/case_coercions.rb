# frozen_string_literal: true

module Platformer
  module Composers
    module ActiveRecord
      module Coercions
        class CaseCoercions < DSLCompose::Parser
          # install all the uppercase coercions for each model
          for_children_of PlatformModel do |child_class:|
            model = ClassMap.get_active_record_class_from_model_class(child_class)

            for_dsl [:char_field, :text_field] do |name:|
              for_method :uppercase do
                description <<~DESCRIPTION
                description <<~DESCRIPTION
                  Create a before_validation callback on this active_record class which
                  uppercases the value of `#{name}` before any create or update operations.
                  Injects into ActiveRecord and overrides the write_attribute method, this
                  will ensure that the coercion happens even if callbacks are skipped.
                DESCRIPTION

                # add the before_validation callback to the active record class
                model.before_validation do
                  value = send(name)
                  unless value.nil?
                    send "#{name}=", value&.to_s&.upcase
                  end
                end

                # inject this into the class and override the write_attribute system
                model.attr_uppercase_coercion name
              end

              for_method :lowercase do
                description <<~DESCRIPTION
                  Create a before_validation callback on this active_record class which
                  lowercases the value of `#{name}` before any create or update operations.
                  Injects into ActiveRecord and overrides the write_attribute method, this
                  will ensure that the coercion happens even if callbacks are skipped.
                DESCRIPTION

                # add the before_validation callback to the active record class
                model.before_validation do
                  value = send(name)
                  unless value.nil?
                    send "#{name}=", value&.to_s&.downcase
                  end
                end

                # inject this into the class and override the write_attribute system
                model.attr_lowercase_coercion name
              end
            end
          end
        end
      end
    end
  end
end
