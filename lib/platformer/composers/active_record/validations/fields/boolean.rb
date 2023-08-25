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

            for_field :boolean_field do |name:, model:, array:, default:, comment_text:, allow_null:|
              unless array
                description <<~DESCRIPTION
                  Create a validation on this active record model which asserts that
                  the value of `#{name}` is #{allow_null ? "null, " : ""}true or false.
                DESCRIPTION
                # add the validation to the active record class
                model.validates name, inclusion: [true, false], allow_nil: allow_null
              end

              for_method :validate_is_true do |message:|
                if array
                  raise IncompatibleWithArrayFieldError, "Can not use this validation on array fields"
                end

                description <<~DESCRIPTION
                  Create a validation on this active record model which asserts that
                  the value of `#{name}` is #{allow_null ? "null or " : ""}true (not false).
                DESCRIPTION

                # add the validation to the active record class (using splat for passing the
                # options because `message: nil` is invalid)
                args = {}
                args[:allow_nil] = allow_null
                args[:inclusion] = [true]
                args[:message] = message unless message.nil?
                model.validates name, **args
              end

              for_method :validate_is_false do |message:|
                if array
                  raise IncompatibleWithArrayFieldError, "Can not use this validation on array fields"
                end

                description <<~DESCRIPTION
                  Create a validation on this active record model which asserts that
                  the value of `#{name}` is #{allow_null ? "null or " : ""}false (not true).
                DESCRIPTION
                # add the validation to the active record class (using splat for passing the
                # options because `message: nil` is invalid)
                args = {}
                args[:allow_nil] = allow_null
                args[:inclusion] = [false]
                args[:message] = message unless message.nil?
                model.validates name, **args
              end
            end
          end
        end
      end
    end
  end
end
