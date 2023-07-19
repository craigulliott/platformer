# frozen_string_literal: true

module Platformer
  module Composers
    module ActiveRecord
      module Validations
        class IntegerValidations < DSLCompose::Parser
          # install all the greater than validations for each model
          for_children_of PlatformModel do |child_class:|
            model = ClassMap.get_active_record_class_from_model_class(child_class)

            for_dsl :integer_field do |name:|
              model.validates name, numericality: {only_integer: true}

              for_method :validate_greater_than do |name:, validation_value:|
                model.validates name, greater_than: validation_value
              end

              for_method :validate_greater_than_or_equal_to do |name:, validation_value:|
                model.validates name, greater_than_or_equal_to: validation_value
              end

              for_method :validate_less_than do |name:, validation_value:|
                model.validates name, less_than: validation_value
              end

              for_method :validate_less_than_or_equal_to do |name:, validation_value:|
                model.validates name, less_than_or_equal_to: validation_value
              end
            end
          end
        end
      end
    end
  end
end
