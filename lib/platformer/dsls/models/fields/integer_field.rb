module Platformer
  module DSLs
    module Models
      module Fields
        module IntegerField
          def self.included klass
            klass.define_dsl :integer_field do
              description "Add an integer field to this model."

              # Arguments
              #
              # the name of the field
              requires :name, :symbol do
                description "The name of your field."
                import_shared :field_name_validators
                # Reserved for timestamps
                validate_not_end_with :_at
              end

              # add an optional attribute which can be used to
              # denote this as an array of integers
              optional :array, :boolean do
                description <<~DESCRIPTION
                  If true, then this field will be an array of integers, and
                  will be backed by an `integer[]` type in PostgreSQL.
                DESCRIPTION
              end

              # Methods
              #
              add_unique_method :default do
                requires :default, :integer
              end

              # Common methods which are shared between fields
              import_shared :allow_null
              import_shared :empty_array_to_null_coercion
              import_shared :unique_field
              import_shared :field_comment
              import_shared :immutable_validators
              import_shared :numeric_validators
              import_shared :zero_to_null_coercion
              import_shared :remove_null_array_values_coercion

              # integer specific validations
              #
              # assert the number is an even number
              add_method :validate_even do
                description <<~DESCRIPTION
                  Ensure that the value provided to this field is even. This will
                  create an active record validation, a database constraint and
                  will be used in API validation and generated documentation.
                DESCRIPTION

                optional :message, :string do
                  description <<~DESCRIPTION
                    The message which will be raised if the validation fails.
                  DESCRIPTION
                end
              end

              # assert the number is an odd number
              add_method :validate_odd do
                description <<~DESCRIPTION
                  Ensure that the value provided to this field is odd. This will
                  create an active record validation, a database constraint and
                  will be used in API validation and generated documentation.
                DESCRIPTION

                optional :message, :string do
                  description <<~DESCRIPTION
                    The message which will be raised if the validation fails.
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
