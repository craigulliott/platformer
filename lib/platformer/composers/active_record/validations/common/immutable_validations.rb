# frozen_string_literal: true

module Platformer
  module Composers
    module ActiveRecord
      module Validations
        module Common
          # Install all the immutable validations for each model
          class ImmutableValidations < DSLCompose::Parser
            class IncompatibleImmutableValidationError < StandardError
            end

            # Process the parser for every decendant of PlatformModel. This includes Models
            # which might be in the class hieracy for a model, but could be abstract and may
            # not have their own coresponding table within the database
            for_children_of PlatformModel do |child_class:|
              # the active record class for models of this type, this was created and the
              # result cached within the CreateStructure parser
              model = ClassMap.get_active_record_class_from_model_class(child_class)

              for_dsl [
                :boolean_field,
                :char_field,
                :citext_field,
                :date_field,
                :date_time_field,
                :double_field,
                :email_field,
                :enum_field,
                :float_field,
                :integer_field,
                :json_field,
                :numeric_field,
                :phone_number_field,
                :text_field
              ] do |name:|
                # is this boolean field allowed to be null
                allow_null = method_called? :allow_null

                for_method :immutable do
                  description <<~DESCRIPTION
                    Create a validation on this active record model which asserts that
                    the value of `#{name}` can not be changed after the record is created.
                  DESCRIPTION

                  # add the validation to the active record class
                  model.validates name, immutable: true
                end

                for_method :immutable_once_set do
                  unless allow_null
                    raise IncompatibleImmutableValidationError, "You can not use `immutable_once_set` on fields which do not allow nil values. Switch this field to allow null values, or use `immutable` instead."
                  end

                  description <<~DESCRIPTION
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
end
