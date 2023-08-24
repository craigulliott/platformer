module Platformer
  module DSLs
    module Models
      module Fields
        module CountryField
          def self.included klass
            klass.define_dsl :country_field do
              description "Add a country field to this model."

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
              # denote this as an array of countrys
              optional :array, :boolean do
                description <<~DESCRIPTION
                  If true, then this field will be an array of countrys, and
                  will be backed by a `platformer.country_codes[]` type in PostgreSQL.
                DESCRIPTION
              end

              # Methods
              #
              add_unique_method :default do
                requires :default, :string
              end

              import_shared :allow_null
              import_shared :empty_array_to_null_coercion
              import_shared :unique_field
              import_shared :field_comment
              import_shared :comparison_validators
              import_shared :immutable_validators
              import_shared :remove_null_array_values_coercion
            end
          end
        end
      end
    end
  end
end
