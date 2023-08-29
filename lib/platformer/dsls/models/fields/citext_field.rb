module Platformer
  module DSLs
    module Models
      module Fields
        module CitextField
          def self.included klass
            klass.define_dsl :citext_field do
              namespace :fields
              title "Add a Citext field to your Model"
              description <<~DESCRIPTION
                Add a citext field to this model. The citext type can store citext of
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
              # denote this as an array of citexts
              optional :array, :boolean do
                description <<~DESCRIPTION
                  If true, then this field will be an array of citexts, and
                  will be backed by a `citext[]` type in PostgreSQL.
                DESCRIPTION
              end

              # Methods
              #
              add_unique_method :default do
                requires :default, :string
              end

              # Common methods which are shared between fields
              import_shared :allow_null
              import_shared :empty_array_to_null_coercion
              import_shared :unique_field
              import_shared :field_comment
              import_shared :immutable_validators
              import_shared :trim_and_nullify_coercion
              import_shared :remove_null_array_values_coercion
              import_shared :string_validators
              import_shared :comparison_validators
            end
          end
        end
      end
    end
  end
end
