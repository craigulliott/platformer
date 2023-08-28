# frozen_string_literal: true

module Platformer
  module Composers
    module ActiveRecord
      module Coercions
        module Common
          class EmptyArrayToNull < Parsers::AllModels::ForFields
            class UnsupportedEmptyArrayToNullError < StandardError
            end

            for_all_fields except: [:jsom_field, :phone_number] do |name:, active_record_class:, array:, allow_null:|
              for_method :empty_array_to_null do
                unless array
                  raise UnsupportedEmptyArrayToNullError, "`empty_array_to_null` can only be used on array fields"
                end

                description <<~DESCRIPTION
                  Create a before_validation callback on this active_record class which
                  will convert `#{name}` into null if it is an empty array. This logic
                  is also injected into ActiveRecord and overrides the write_attribute method,
                  this will ensure that the coercion happens even if callbacks are skipped.
                DESCRIPTION

                # add the before_validation callback to the active record class
                active_record_class.before_validation do
                  value = send(name)
                  if value.is_a?(Array) && value.empty?
                    send "#{name}=", nil
                  end
                end

                # inject this into the class and override the write_attribute system
                active_record_class.attr_empty_array_to_null_coercion name
              end
            end
          end
        end
      end
    end
  end
end
