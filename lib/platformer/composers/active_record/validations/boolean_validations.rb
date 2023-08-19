# frozen_string_literal: true

module Platformer
  module Composers
    module ActiveRecord
      module Validations
        # install all the validations specifically designed for boolean fields
        class BooleanValidations < DSLCompose::Parser
          class IncompatibleWithArrayFieldError < StandardError
          end

          # Process the parser for every decendant of PlatformModel. This includes Models
          # which might be in the class hieracy for a model, but could be abstract and may
          # not have their own coresponding table within the database
          for_children_of PlatformModel do |child_class:|
            # the active record class for models of this type, this was created and the
            # result cached within the CreateStructure parser
            model = ClassMap.get_active_record_class_from_model_class(child_class)

            # for each boolean field on this Model or any of it's ancestors
            for_dsl [:boolean_field] do |name:, array:|
              # is this boolean field allowed to be null
              allow_null = method_called? :allow_null

              unless array
                description <<~DESCRIPTION
                  Create an validation on this active record model which asserts that
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
