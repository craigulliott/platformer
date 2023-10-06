# frozen_string_literal: true

module Platformer
  module Composers
    module ActiveRecord
      module Coercions
        module Common
          class EmptyArrayToNull < Parsers::Models::ForFields
            class UnsupportedEmptyArrayToNullError < StandardError
            end

            for_all_single_column_fields except: :json_field do |column_name:, active_record_class:, array:, allow_null:|
              for_method :empty_array_to_null do
                unless array
                  raise UnsupportedEmptyArrayToNullError, "`empty_array_to_null` can only be used on array fields"
                end

                add_documentation <<~DESCRIPTION
                  Create a before_validation callback on this active_record class which
                  will convert `#{column_name}` into null if it is an empty array. This logic
                  is also injected into ActiveRecord and overrides the write_attribute method,
                  this will ensure that the coercion happens even if callbacks are skipped.
                DESCRIPTION

                # add the before_validation callback to the active record class
                active_record_class.before_validation do
                  value = send(column_name)
                  if value.is_a?(Array) && value.empty?
                    send "#{column_name}=", nil
                  end
                end

                # inject this into the class and override the write_attribute system
                active_record_class.attr_empty_array_to_null_coercion column_name
              end
            end
          end
        end
      end
    end
  end
end
