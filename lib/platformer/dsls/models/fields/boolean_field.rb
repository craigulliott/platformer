module Platformer
  module DSLs
    module Models
      module Fields
        module BooleanField
          def self.included klass
            klass.define_dsl :boolean_field do
              namespace :fields
              title "Add a Boolean field to your Model"
              description "Add a boolean field to this model."

              # the name of the field
              requires :name, :symbol do
                description "The name of this boolean field"
                import_shared :field_name_validators
                # Reserved for timestamps
                validate_not_end_with :_at
              end

              # add an optional attribute which can be used to
              # denote this as an array of booleans
              optional :array, :boolean do
                description <<~DESCRIPTION
                  If true, then this field will be an array of booleans, and
                  will be backed by a `bool[]` type in PostgreSQL.
                DESCRIPTION
              end

              # Methods
              #
              add_unique_method :default do
                requires :default, :boolean
              end

              # Common methods which are shared between fields
              import_shared :allow_null
              import_shared :empty_array_to_null_coercion
              import_shared :unique_field
              import_shared :field_description
              import_shared :immutable_validators
              import_shared :remove_null_array_values_coercion

              # boolean specific validations
              #
              # assert the boolean is true
              add_method :validate_is_true do
                description <<~DESCRIPTION
                  Ensure that the value provided to this field is `true`.
                DESCRIPTION

                optional :message, :string do
                  description <<~DESCRIPTION
                    The message which will be raised if the validation fails.
                  DESCRIPTION
                end

                optional :comment, :string do
                  description <<~DESCRIPTION
                    A comment which explains the reason for this validation
                    on this field. This will be used to generate documentation,
                    and will be added as a comment to the database constraint.
                  DESCRIPTION
                end
              end

              # assert the boolean is false
              add_method :validate_is_false do
                description <<~DESCRIPTION
                  Ensure that the value provided to this field is `false`.
                DESCRIPTION

                optional :message, :string do
                  description <<~DESCRIPTION
                    The message which will be raised if the validation fails.
                  DESCRIPTION
                end

                optional :comment, :string do
                  description <<~DESCRIPTION
                    A comment which explains the reason for this validation
                    on this field. This will be used to generate documentation,
                    and will be added as a comment to the database constraint.
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
