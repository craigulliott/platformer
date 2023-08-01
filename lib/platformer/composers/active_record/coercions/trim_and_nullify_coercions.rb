# frozen_string_literal: true

module Platformer
  module Composers
    module ActiveRecord
      module Coercions
        class TrimAndNullifyCoercions < DSLCompose::Parser
          # install all the trim_and_nullify coercions for each model
          for_children_of PlatformModel do |child_class:|
            model = ClassMap.get_active_record_class_from_model_class(child_class)

            for_dsl [:char_field, :text_field] do |name:|
              for_method :trim_and_nullify do
                description <<-DESCRIPTION
                  Create a before_validation callback on this active_record class which
                  strips any whitespace off the front and back of the value of the `#{name}`
                  field, and will also convert any empty strings to null.
                DESCRIPTION

                # add the before_validation callback to the active record class
                model.before_validation do
                  value = send(name)
                  unless value.nil?
                    value = value.to_s.strip
                    send "#{name}=", (value == "") ? nil : value
                  end
                end

                # inject this into the class and override the write_attribute system
                model.attr_trim_and_nullify_coercion name
              end
            end
          end
        end
      end
    end
  end
end
