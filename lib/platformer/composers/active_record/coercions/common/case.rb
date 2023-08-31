# frozen_string_literal: true

module Platformer
  module Composers
    module ActiveRecord
      module Coercions
        module Common
          class Case < Parsers::AllModels::ForFields
            # install all the uppercase coercions for each model
            for_string_fields except: :citext_field do |name:, active_record_class:, array:, allow_null:|
              for_method [:uppercase, :lowercase] do |method_name:|
                wanted_case = method_name

                add_documentation <<~DESCRIPTION
                  Create a before_validation callback on this active_record class which
                  #{wanted_case}s #{array ? "all values" : "the value"} of `#{name}` before any
                  create or update operations. This logic is also injected into ActiveRecord
                  and overrides the write_attribute method, this will ensure that the coercion
                  happens even if callbacks are skipped.
                DESCRIPTION

                case_change_method_name = (method_name == :uppercase) ? :upcase : :downcase

                # add the before_validation callback to the active record class
                if array
                  active_record_class.before_validation do
                    value = send(name)
                    if value.is_a?(Array)
                      send "#{name}=", value.map { |v| v.is_a?(String) ? v.send(case_change_method_name) : v }
                    end
                  end
                else
                  active_record_class.before_validation do
                    value = send(name)
                    if value.is_a? String
                      send "#{name}=", value.send(case_change_method_name)
                    end
                  end
                end

                # inject this into the class and override the write_attribute system
                active_record_class.send(:"attr_#{wanted_case}_coercion", name)
              end
            end
          end
        end
      end
    end
  end
end
