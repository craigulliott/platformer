module Platformer
  module DSLs
    module Models
      module Fields
        module BooleanField
          def self.included klass
            klass.define_dsl :boolean_field do
              description "Add an boolean field to this model."

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
                description <<-DESCRIPTION
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
              import_shared :unique_field
              import_shared :field_comment
              import_shared :immutable_validators

              # boolean specific validations
              #
              # assert the boolean is true
              add_method :validate_is_true do
                description <<-DESCRIPTION
                  Ensure that the value provided to this field is `true`.
                DESCRIPTION

                optional :message, :string do
                  description <<-DESCRIPTION
                    The message which will be raised if the validation fails.
                  DESCRIPTION
                end
              end

              # assert the boolean is false
              add_method :validate_is_false do
                description <<-DESCRIPTION
                  Ensure that the value provided to this field is `false`.
                DESCRIPTION

                optional :message, :string do
                  description <<-DESCRIPTION
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
