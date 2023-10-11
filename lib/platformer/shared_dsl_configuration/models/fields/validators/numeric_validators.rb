module Platformer
  module DSLs
    module SharedDSLConfiguration
      module Models
        module Fields
          module Validators
            module NumericValidators
              # validators which are shared between all numeric fields
              DSLCompose::SharedConfiguration.add :numeric_validators do
                add_method :validate_greater_than do
                  description <<~DESCRIPTION
                    Ensure that the value provided to this field is greater than a
                    provided value. This will create an active record validation,
                    a database constraint and will be used in API validation and
                    generated documentation.
                  DESCRIPTION

                  requires :value, :float do
                    description <<~DESCRIPTION
                      The value to validate against. The provided value must be greater
                      than this value
                    DESCRIPTION
                  end

                  optional :message, :string do
                    description <<~DESCRIPTION
                      The message which will be displayed if the validation fails.
                    DESCRIPTION
                  end

                  optional :description, :string do
                    description <<~DESCRIPTION
                      A description which explains the reason for this validation
                      on this field. This will be used to generate documentation,
                      and will be added as a description to the database constraint.
                    DESCRIPTION
                  end
                end

                add_method :validate_greater_than_or_equal_to do
                  description <<~DESCRIPTION
                    Ensure that the value provided to this field is greater than
                    or equal to a provided value. This will create an active record
                    validation, a database constraint and will be used in API
                    validation and generated documentation.
                  DESCRIPTION

                  requires :value, :float do
                    description <<~DESCRIPTION
                      The value to validate against. The provided value must be greater
                      than or equal to this value
                    DESCRIPTION
                  end

                  optional :message, :string do
                    description <<~DESCRIPTION
                      The message which will be displayed if the validation fails.
                    DESCRIPTION
                  end

                  optional :description, :string do
                    description <<~DESCRIPTION
                      A description which explains the reason for this validation
                      on this field. This will be used to generate documentation,
                      and will be added as a description to the database constraint.
                    DESCRIPTION
                  end
                end

                add_method :validate_less_than do
                  description <<~DESCRIPTION
                    Ensure that the value provided to this field is less than a
                    provided value. This will create an active record validation,
                    a database constraint and will be used in API validation and
                    generated documentation.
                  DESCRIPTION

                  requires :value, :float do
                    description <<~DESCRIPTION
                      The value to validate against. The provided value must be less
                      than this value
                    DESCRIPTION
                  end

                  optional :message, :string do
                    description <<~DESCRIPTION
                      The message which will be displayed if the validation fails.
                    DESCRIPTION
                  end

                  optional :description, :string do
                    description <<~DESCRIPTION
                      A description which explains the reason for this validation
                      on this field. This will be used to generate documentation,
                      and will be added as a description to the database constraint.
                    DESCRIPTION
                  end
                end

                add_method :validate_less_than_or_equal_to do
                  description <<~DESCRIPTION
                    Ensure that the value provided to this field is less than
                    or equal to a provided value. This will create an active record
                    validation, a database constraint and will be used in API
                    validation and generated documentation.
                  DESCRIPTION

                  requires :value, :float do
                    description <<~DESCRIPTION
                      The value to validate against. The provided value must be less
                      than or equal to this value
                    DESCRIPTION
                  end

                  optional :message, :string do
                    description <<~DESCRIPTION
                      The message which will be displayed if the validation fails.
                    DESCRIPTION
                  end

                  optional :description, :string do
                    description <<~DESCRIPTION
                      A description which explains the reason for this validation
                      on this field. This will be used to generate documentation,
                      and will be added as a description to the database constraint.
                    DESCRIPTION
                  end
                end

                add_method :validate_equal_to do
                  description <<~DESCRIPTION
                    Ensure that the value provided to this field is equal to a
                    provided value. This will create an active record validation,
                    a database constraint and will be used in API validation and
                    generated documentation.
                  DESCRIPTION

                  requires :value, :float do
                    description <<~DESCRIPTION
                      The value to validate against. The provided value must be
                      equal to this value
                    DESCRIPTION
                  end

                  optional :message, :string do
                    description <<~DESCRIPTION
                      The message which will be displayed if the validation fails.
                    DESCRIPTION
                  end

                  optional :description, :string do
                    description <<~DESCRIPTION
                      A description which explains the reason for this validation
                      on this field. This will be used to generate documentation,
                      and will be added as a description to the database constraint.
                    DESCRIPTION
                  end
                end

                add_method :validate_in do
                  description <<~DESCRIPTION
                    Ensure that the value provided to this field is equal to one of
                    the provided values. This will create an active record validation,
                    a database constraint and will be used in API validation and
                    generated documentation.
                  DESCRIPTION

                  requires :value, :float, array: true do
                    description <<~DESCRIPTION
                      The value or array of values to validate against. The provided
                      value must be equal to one of these values.
                    DESCRIPTION
                  end

                  optional :message, :string do
                    description <<~DESCRIPTION
                      The message which will be displayed if the validation fails.
                    DESCRIPTION
                  end

                  optional :description, :string do
                    description <<~DESCRIPTION
                      A description which explains the reason for this validation
                      on this field. This will be used to generate documentation,
                      and will be added as a description to the database constraint.
                    DESCRIPTION
                  end
                end

                add_method :validate_not_in do
                  description <<~DESCRIPTION
                    Ensure that the value provided to this field is not equal to one of
                    the provided values. This will create an active record validation,
                    a database constraint and will be used in API validation and
                    generated documentation.
                  DESCRIPTION

                  requires :value, :float, array: true do
                    description <<~DESCRIPTION
                      The value or array of values to validate against. The provided
                      value must not be equal to any of these values.
                    DESCRIPTION
                  end

                  optional :message, :string do
                    description <<~DESCRIPTION
                      The message which will be displayed if the validation fails.
                    DESCRIPTION
                  end

                  optional :description, :string do
                    description <<~DESCRIPTION
                      A description which explains the reason for this validation
                      on this field. This will be used to generate documentation,
                      and will be added as a description to the database constraint.
                    DESCRIPTION
                  end
                end
              end
            end
          end
        end
      end
    end
  end
end
