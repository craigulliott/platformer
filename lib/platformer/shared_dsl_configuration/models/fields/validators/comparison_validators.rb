module Platformer
  module DSLs
    module SharedDSLConfiguration
      module Models
        module Fields
          module Validators
            module TextValidators
              # validators which are shared between all string like fields
              DSLCompose::SharedConfiguration.add :comparison_validators do
                add_method :validate_in do
                  description <<~DESCRIPTION
                    Ensures that the value of this field matches one of the provided values.
                    This will create an active record validation, a database
                    constraint and will be used in API validation and generated
                    documentation.
                  DESCRIPTION

                  requires :values, :string, array: true do
                    description <<~DESCRIPTION
                      The array of strings to compare the value against.
                    DESCRIPTION
                  end

                  # add `deferrable: boolean` and `initially_deferred: boolean` options
                  import_shared :deferrable_constraint

                  optional :message, :string do
                    description <<~DESCRIPTION
                      The message which will be raised if the validation fails.
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
                    Ensures that the value of this field is not equal to any
                    of the provided values.
                    This will create an active record validation, a database
                    constraint and will be used in API validation and generated
                    documentation.
                  DESCRIPTION

                  requires :values, :string, array: true do
                    description <<~DESCRIPTION
                      The array of strings to compare the value against.
                    DESCRIPTION
                  end

                  # add `deferrable: boolean` and `initially_deferred: boolean` options
                  import_shared :deferrable_constraint

                  optional :message, :string do
                    description <<~DESCRIPTION
                      The message which will be raised if the validation fails.
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

                add_method :validate_is_value do
                  description <<~DESCRIPTION
                    Ensures that the value of this field is equal to the provided value
                    This will create an active record validation, a database
                    constraint and will be used in API validation and generated
                    documentation.
                  DESCRIPTION

                  requires :value, :string do
                    description <<~DESCRIPTION
                      The value to compare against.
                    DESCRIPTION
                  end

                  # add `deferrable: boolean` and `initially_deferred: boolean` options
                  import_shared :deferrable_constraint

                  optional :message, :string do
                    description <<~DESCRIPTION
                      The message which will be raised if the validation fails.
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
