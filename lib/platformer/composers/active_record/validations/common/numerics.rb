# frozen_string_literal: true

module Platformer
  module Composers
    module ActiveRecord
      module Validations
        module Common
          # install all the common/shared numeric validations for each model
          class Numerics < FieldParser
            class IncompatibleWithArrayFieldError < StandardError
            end

            for_numeric_fields do |name:, model:, array:, dsl_name:, allow_null:|
              unless array
                if dsl_name == :integer_field
                  description <<~DESCRIPTION
                    Create a validation on this active record model which asserts that
                    the value of `#{name}` is numerical and a whole number.
                  DESCRIPTION
                  # add the validation to the active record class
                  model.validates name, allow_nil: allow_null, numericality: {only_integer: true}
                else
                  description <<~DESCRIPTION
                    Create a validation on this active record model which asserts that
                    the value of `#{name}` is numerical.
                  DESCRIPTION
                  # add the validation to the active record class
                  model.validates name, allow_nil: allow_null, numericality: true
                end
              end

              for_method [
                :validate_greater_than,
                :validate_greater_than_or_equal_to,
                :validate_less_than,
                :validate_less_than_or_equal_to
              ] do |value:, message:, method_name:|
                if array
                  raise IncompatibleWithArrayFieldError, "Can not use this validation on array fields"
                end

                # the difference between these validations
                case method_name
                when :validate_greater_than
                  desc = "greater_than"
                  validation_method_name = :greater_than

                when :validate_greater_than_or_equal_to
                  desc = "greater than or equal to"
                  validation_method_name = :greater_than_or_equal_to

                when :validate_less_than
                  desc = "less than"
                  validation_method_name = :less_than

                when :validate_less_than_or_equal_to
                  desc = "less than or equal to"
                  validation_method_name = :less_than_or_equal_to
                end

                description <<~DESCRIPTION
                  Create a validation on this active record model which asserts that
                  the value of `#{name}` #{desc} #{value}.
                DESCRIPTION

                # add the validation to the active record class (using splat for passing the
                # options because `message: nil` is invalid)
                args = {}
                args[:allow_nil] = allow_null
                args[:numericality] = {
                  validation_method_name => value
                }
                args[:numericality][:message] = message unless message.nil?
                model.validates name, **args
              end

              for_method :validate_equal_to do |value:, message:|
                if array
                  raise IncompatibleWithArrayFieldError, "Can not use this validation on array fields"
                end

                description <<~DESCRIPTION
                  Create a validation on this active record model which asserts that
                  the value of `#{name}` is equal to the number #{value}.
                DESCRIPTION

                # add the validation to the active record class
                model.validates name, {
                  allow_nil: allow_null,
                  inclusion: {
                    in: [value],
                    message: message || "must equal #{value}"
                  }
                }
              end
            end
          end
        end
      end
    end
  end
end
