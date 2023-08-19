# frozen_string_literal: true

module Platformer
  module Composers
    module ActiveRecord
      module Validations
        module Common
          # install all the common/shared numeric validations for each model
          class NumericValidations < DSLCompose::Parser
            class IncompatibleWithArrayFieldError < StandardError
            end

            # Process the parser for every decendant of PlatformModel. This includes Models
            # which might be in the class hieracy for a model, but could be abstract and may
            # not have their own coresponding table within the database
            for_children_of PlatformModel do |child_class:|
              # the active record class for models of this type, this was created and the
              # result cached within the CreateStructure parser
              model = ClassMap.get_active_record_class_from_model_class(child_class)

              # for each number field on this Model or any of it's ancestors
              for_dsl [:integer_field, :float_field, :double_field, :numeric_field] do |name:, array:|
                unless array
                  description <<~DESCRIPTION
                    Create an validation on this active record model which asserts that
                    the value of `#{name}` is an integer and a whole number.
                  DESCRIPTION
                  # add the validation to the active record class
                  model.validates name, numericality: {only_integer: true}
                end

                for_method :validate_greater_than do |value:|
                  if array
                    raise IncompatibleWithArrayFieldError, "Can not use this validation on array fields"
                  end

                  description <<~DESCRIPTION
                    Create a validation on this active record model which asserts that
                    the value of `#{name}` is greater than #{value}.
                  DESCRIPTION
                  # add the validation to the active record class
                  model.validates name, greater_than: value
                end

                for_method :validate_greater_than_or_equal_to do |value:|
                  if array
                    raise IncompatibleWithArrayFieldError, "Can not use this validation on array fields"
                  end

                  description <<~DESCRIPTION
                    Create a validation on this active record model which asserts that
                    the value of `#{name}` is greater than or equal to #{value}.
                  DESCRIPTION
                  # add the validation to the active record class
                  model.validates name, numericality: {greater_than_or_equal_to: value}
                end

                for_method :validate_less_than do |value:|
                  if array
                    raise IncompatibleWithArrayFieldError, "Can not use this validation on array fields"
                  end

                  description <<~DESCRIPTION
                    Create a validation on this active record model which asserts that
                    the value of `#{name}` is less than #{value}.
                  DESCRIPTION
                  # add the validation to the active record class
                  model.validates name, numericality: {less_than: value}
                end

                for_method :validate_less_than_or_equal_to do |value:|
                  if array
                    raise IncompatibleWithArrayFieldError, "Can not use this validation on array fields"
                  end

                  description <<~DESCRIPTION
                    Create a validation on this active record model which asserts that
                    the value of `#{name}` is less than or equal to #{value}.
                  DESCRIPTION
                  # add the validation to the active record class
                  model.validates name, numericality: {less_than_or_equal_to: value}
                end

                for_method :validate_equal_to do |value:|
                  if array
                    raise IncompatibleWithArrayFieldError, "Can not use this validation on array fields"
                  end

                  description <<~DESCRIPTION
                    Create a validation on this active record model which asserts that
                    the value of `#{name}` is equal to the number #{value}.
                  DESCRIPTION
                  # add the validation to the active record class
                  model.validates name, numericality: {equal_to: value}
                end
              end
            end
          end
        end
      end
    end
  end
end
