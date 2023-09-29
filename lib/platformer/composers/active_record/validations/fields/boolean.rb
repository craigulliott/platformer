# frozen_string_literal: true

module Platformer
  module Composers
    module ActiveRecord
      module Validations
        module Fields
          # install all the validations specifically designed for boolean fields
          class Boolean < Parsers::AllModels::ForFields
            class IncompatibleWithArrayFieldError < StandardError
            end

            for_field :boolean_field do |name:, active_record_class:, array:, default:, description:, allow_null:|
              unless array
                add_documentation <<~DESCRIPTION
                  Create a validation on this active record model which asserts that
                  the value of `#{name}` is #{allow_null ? "null, " : ""}true or false.
                DESCRIPTION
                # add the validation to the active record class
                active_record_class.validates name, inclusion: [true, false], allow_nil: allow_null
              end

              for_method :validate_is_true do |message:|
                if array
                  raise IncompatibleWithArrayFieldError, "Can not use this validation on array fields"
                end

                add_documentation <<~DESCRIPTION
                  Create a validation on this active record model which asserts that
                  the value of `#{name}` is #{allow_null ? "null or " : ""}true (not false).
                DESCRIPTION

                # add the validation to the active record class (using splat for passing the
                # options because `message: nil` is invalid)
                args = {}
                args[:allow_nil] = allow_null
                args[:inclusion] = [true]
                args[:message] = message unless message.nil?
                active_record_class.validates name, **args
              end

              for_method :validate_is_false do |message:|
                if array
                  raise IncompatibleWithArrayFieldError, "Can not use this validation on array fields"
                end

                add_documentation <<~DESCRIPTION
                  Create a validation on this active record model which asserts that
                  the value of `#{name}` is #{allow_null ? "null or " : ""}false (not true).
                DESCRIPTION
                # add the validation to the active record class (using splat for passing the
                # options because `message: nil` is invalid)
                args = {}
                args[:allow_nil] = allow_null
                args[:inclusion] = [false]
                args[:message] = message unless message.nil?
                active_record_class.validates name, **args
              end
            end
          end
        end
      end
    end
  end
end
