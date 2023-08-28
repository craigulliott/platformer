# frozen_string_literal: true

module Platformer
  module Composers
    module ActiveRecord
      module Validations
        module Common
          # install all the common/shared string validations for each model
          class Strings < Parsers::AllModels::ForFields
            class IncompatibleWithArrayFieldError < StandardError
            end

            for_string_fields do |name:, active_record_class:, array:, allow_null:|
              for_method [
                :validate_minimum_length,
                :validate_maximum_length,
                :validate_length_is
              ] do |method_name:, value:, message:|
                if array
                  raise IncompatibleWithArrayFieldError, "Can not use this validation on array fields"
                end

                # the difference between the three length validations
                case method_name
                when :validate_minimum_length
                  desc = "be at least #{value} characters long"
                  validation_key = :minimum

                when :validate_maximum_length
                  desc = "be no longer than #{value} characters"
                  validation_key = :maximum

                when :validate_length_is
                  desc = "have exactly #{value} characters"
                  validation_key = :is
                end

                description <<~DESCRIPTION
                  Create a validation on this active record model which asserts that
                  the value of `#{name}` #{desc}.
                DESCRIPTION

                # add the validation to the active record class (using splat for passing the
                # options because `message: nil` is invalid)
                args = {}
                args[:allow_nil] = allow_null
                args[:length] = {
                  validation_key => value
                }
                args[:length][:message] = message unless message.nil?
                active_record_class.validates name, **args
              end

              for_method :validate_format do |value:, message:|
                if array
                  raise IncompatibleWithArrayFieldError, "Can not use this validation on array fields"
                end

                description <<~DESCRIPTION
                  Create a validation on this active record model which asserts that
                  the value of `#{name}` is of the format #{value}.
                DESCRIPTION

                # add the validation to the active record class (using splat for passing the
                # options because `message: nil` is invalid)
                args = {}
                args[:allow_nil] = allow_null
                args[:format] = {
                  with: value
                }
                args[:format][:message] = message unless message.nil?
                active_record_class.validates name, **args
              end

              for_method [
                :validate_in,
                :validate_not_in
              ] do |method_name:, values:, message:|
                if array
                  raise IncompatibleWithArrayFieldError, "Can not use this validation on array fields"
                end

                # so we can easily differentiate between these two methods
                not_in = method_name == :validate_not_in

                description <<~DESCRIPTION
                  Create a validation on this active record model which asserts that
                  the value of `#{name}` must #{not_in ? "not be" : "be"} one of
                  #{values.to_sentence}.
                DESCRIPTION

                # add the validation to the active record class (using splat for passing the
                # options because `message: nil` is invalid)
                args = {}
                if not_in
                  args[:exclusion] = {
                    in: values
                    # `allow_nil` has no effect on exclusion validations
                  }
                  args[:exclusion][:message] = message unless message.nil?
                else
                  args[:inclusion] = {
                    in: values,
                    allow_nil: allow_null
                  }
                  args[:inclusion][:message] = message unless message.nil?
                end
                active_record_class.validates name, **args
              end

              for_method :validate_is_value do |value:, message:|
                if array
                  raise IncompatibleWithArrayFieldError, "Can not use this validation on array fields"
                end

                description <<~DESCRIPTION
                  Create a validation on this active record model which asserts that
                  the value of `#{name}` is exactly `#{value}`.
                DESCRIPTION

                # add the validation to the active record class
                active_record_class.validates name, {
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
