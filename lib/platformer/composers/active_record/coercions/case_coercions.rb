# frozen_string_literal: true

module Platformer
  module Composers
    module ActiveRecord
      module Coercions
        class CaseCoercions < DSLCompose::Parser
          # install all the uppercase coercions for each model
          for_children_of PlatformModel do |child_class:|
            model = ClassMap.get_active_record_class_from_model_class(child_class)

            for_dsl [:char_field, :text_field] do |array:, name:|
              for_method [:uppercase, :lowercase] do |method_name:|
                wanted_case = method_name
                unwanted_case = (method_name == :uppercase) ? :lowercase : :uppercase

                description <<~DESCRIPTION
                  Create a before_validation callback on this active_record class which
                  #{wanted_case}s #{array ? "all values" : "the value"} of `#{name}` before any
                  create or update operations. This logic is also injected into ActiveRecord
                  and overrides the write_attribute method, this will ensure that the coercion
                  happens even if callbacks are skipped.
                DESCRIPTION

                case_change_method_name = (method_name == :uppercase) ? :upcase : :downcase

                # add the before_validation callback to the active record class
                if array
                  model.before_validation do
                    value = send(name)
                    if value.is_a?(Array)
                      send "#{name}=", value.map { |v| v.is_a?(String) ? v.send(case_change_method_name) : v }
                    end
                  end
                else
                  model.before_validation do
                    value = send(name)
                    if value.is_a? String
                      send "#{name}=", value.send(case_change_method_name)
                    end
                  end
                end

                # inject this into the class and override the write_attribute system
                model.send(:"attr_#{wanted_case}_coercion", name)
              end
            end
          end
        end
      end
    end
  end
end
