module Platformer
  module DSLs
    module Models
      module Fields
        module EnumField
          def self.included klass
            klass.define_dsl :enum_field do
              namespace :fields
              title "Add an Enum field to your Model"
              description "Add an enum field to this model."

              # Arguments
              #
              # the name of the field
              requires :name, :symbol do
                description "The name of your field."
                import_shared :field_name_validators
                # Reserved for timestamps
                validate_not_end_with :_at
              end

              # the array of values
              requires :values, :string, array: true do
                description "The possible values for this enum."
              end

              # add an optional attribute which can be used to
              # denote this as an array of enums
              optional :array, :boolean do
                description <<~DESCRIPTION
                  If true, then this field will be an array of enums, and
                  will be backed by a `your_enum_name[]` type in PostgreSQL.
                DESCRIPTION
              end

              # Common methods which are shared between fields
              import_shared :default
              import_shared :database_default
              import_shared :allow_null
              import_shared :empty_array_to_null_coercion
              import_shared :unique_field
              import_shared :field_description
              import_shared :immutable_validators
              import_shared :comparison_validators
              import_shared :remove_null_array_values_coercion
            end
          end
        end
      end
    end
  end
end
