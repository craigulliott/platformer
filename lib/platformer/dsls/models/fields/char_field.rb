module Platformer
  module DSLs
    module Models
      module Fields
        module CharField
          def self.included klass
            klass.define_dsl :char_field do
              description <<~DESCRIPTION
                Add a char field to this model. The char type can store text of
                a specific length.
              DESCRIPTION

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
              # denote this as an array of chars
              optional :array, :boolean do
                description <<~DESCRIPTION
                  If true, then this field will be an array of chars, and
                  will be backed by a `char(length)[]` type in PostgreSQL.
                DESCRIPTION
              end

              optional :length, :integer do
                description <<~DESCRIPTION
                  If provided, then length is the total number of characters
                  which can be held in this field.
                DESCRIPTION

                validate_greater_than 0
              end

              # Methods
              #
              add_unique_method :default do
                requires :default, :string
              end

              # Common methods which are shared between fields
              import_shared :allow_null
              import_shared :unique_field
              import_shared :field_comment
              import_shared :immutable_validators
              import_shared :lowercase_coercion
              import_shared :uppercase_coercion
              import_shared :trim_and_nullify_coercion
            end
          end
        end
      end
    end
  end
end
