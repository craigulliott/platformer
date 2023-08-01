# frozen_string_literal: true

module Platformer
  module Composers
    module ActiveRecord
      module Validations
        class ImmutableValidations < DSLCompose::Parser
          # install all the immurable validations for each model
          for_children_of PlatformModel do |child_class:|
            model = ClassMap.get_active_record_class_from_model_class(child_class)

            for_dsl [:integer_field, :float_field, :double_field, :numeric_field] do |name:|
              for_method :immutable do
                description <<-DESCRIPTION
                  Create a validation on this active record model which asserts that
                  the value of `#{name}` can not be changed after the record is created.
                DESCRIPTION
                # add the validation to the active record class
                model.validates name, immutable: true
              end

              for_method :immutable_once_set do
                description <<-DESCRIPTION
                  Create a validation on this active record model which asserts that
                  the value of `#{name}` can not be changed after the value has been set.
                  If a record exists, and the value is null, then it can be set at any
                  time. As soon as the value is updated to a non null value, it is locked
                  and can not be changed.
                DESCRIPTION
                # add the validation to the active record class
                model.validates name, immutable_once_set: true
              end
            end
          end
        end
      end
    end
  end
end
