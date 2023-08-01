# frozen_string_literal: true

module Platformer
  module Composers
    module ActiveRecord
      module Validations
        class NumericValidations < DSLCompose::Parser
          # install all the common numeric validations for each model
          for_children_of PlatformModel do |child_class:|
            model = ClassMap.get_active_record_class_from_model_class(child_class)

            for_dsl [:integer_field, :float_field, :double_field, :numeric_field] do |name:|
              description <<-DESCRIPTION
                Create an validation on this active record model which asserts that
                the value of `#{name}` is an integer and a whole number.
              DESCRIPTION
              # add the validation to the active record class
              model.validates name, numericality: {only_integer: true}

              for_method :validate_greater_than do |value:|
                description <<-DESCRIPTION
                  Create a validation on this active record model which asserts that
                  the value of `#{name}` is greater than #{value}.
                DESCRIPTION
                # add the validation to the active record class
                model.validates name, greater_than: value
              end

              for_method :validate_greater_than_or_equal_to do |value:|
                description <<-DESCRIPTION
                  Create a validation on this active record model which asserts that
                  the value of `#{name}` is greater than or equal to #{value}.
                DESCRIPTION
                # add the validation to the active record class
                model.validates name, numericality: {greater_than_or_equal_to: value}
              end

              for_method :validate_less_than do |value:|
                description <<-DESCRIPTION
                  Create a validation on this active record model which asserts that
                  the value of `#{name}` is less than #{value}.
                DESCRIPTION
                # add the validation to the active record class
                model.validates name, numericality: {less_than: value}
              end

              for_method :validate_less_than_or_equal_to do |value:|
                description <<-DESCRIPTION
                  Create a validation on this active record model which asserts that
                  the value of `#{name}` is less than or equal to #{value}.
                DESCRIPTION
                # add the validation to the active record class
                model.validates name, numericality: {less_than_or_equal_to: value}
              end

              for_method :validate_equal_to do |value:|
                description <<-DESCRIPTION
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
