# frozen_string_literal: true

module Platformer
  module Composers
    module ActiveRecord
      module Coercions
        module Common
          class TrimAndNullify < Parsers::Models::ForFields
            # install all the trim_and_nullify coercions for each model
            for_string_fields do |name:, active_record_class:, array:, allow_null:|
              for_method :trim_and_nullify do
                add_documentation <<~DESCRIPTION
                  Create a before_validation callback on this active_record class which
                  strips any whitespace off the front and back of
                  #{array ? "all values" : "the value"} of the `#{name}`
                  field, and will also convert any empty strings to null. This logic is also
                  injected into ActiveRecord and overrides the write_attribute method, this
                  will ensure that the coercion happens even if callbacks are skipped.
                DESCRIPTION

                # add the before_validation callback to the active record class
                if array
                  active_record_class.before_validation do
                    value = send(name)
                    if value.is_a?(Array)
                      send "#{name}=", value.map { |v| v.is_a?(String) ? v.strip : v }.map { |v| (v == "") ? nil : v }
                    end
                  end
                else
                  active_record_class.before_validation do
                    value = send(name)
                    if value.is_a? String
                      v = value.strip
                      send "#{name}=", (v == "") ? nil : v
                    end
                  end
                end

                # inject this into the class and override the write_attribute system
                active_record_class.attr_trim_and_nullify_coercion name
              end
            end
          end
        end
      end
    end
  end
end
