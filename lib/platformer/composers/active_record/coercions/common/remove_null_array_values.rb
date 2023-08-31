# frozen_string_literal: true

module Platformer
  module Composers
    module ActiveRecord
      module Coercions
        module Common
          class RemoveNullArrayValues < Parsers::AllModels::ForFields
            # install all the remove_null_array_values coercions for each model
            for_all_fields except: [:json_field, :phone_number_field] do |name:, active_record_class:, array:, allow_null:|
              for_method :remove_null_array_values do
                unless array
                  raise UnsupportedRemoveNullArrayValuesError, "`remove_null_array_values` can only be used on array fields"
                end

                add_documentation <<~DESCRIPTION
                  Create a before_validation callback on this active_record class which
                  will remove any null values from the `#{name}` array column. This logic
                  is also injected into ActiveRecord and overrides the write_attribute method,
                  this will ensure that the coercion happens even if callbacks are skipped.
                DESCRIPTION

                # add the before_validation callback to the active record class
                active_record_class.before_validation do
                  value = send(name)
                  if value.is_a?(Array)
                    send "#{name}=", value.filter { |v| !v.nil? }
                  end
                end

                # inject this into the class and override the write_attribute system
                active_record_class.attr_remove_null_array_values_coercion name
              end
            end
          end
        end
      end
    end
  end
end
