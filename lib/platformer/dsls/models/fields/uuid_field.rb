module Platformer
  module DSLs
    module Models
      module Fields
        module UuidField
          def self.included klass
            klass.define_dsl :uuid_field do
              namespace :fields
              title "Add a UUID field to your Model"
              description "Add a field to this model for storing IPv4 and IPv6 hosts and networks."

              # Arguments
              #
              # the name of the field
              requires :name, :symbol do
                description "The name of your field."
                import_shared :snake_case_name_validator
                validate_length minimum: 1, maximum: 63
              end

              import_shared :allow_null

              # add an optional attribute which can be used to
              # denote this as an array of uuids
              optional :array, :boolean do
                description <<~DESCRIPTION
                  If true, then this field will be an array of uuids, and
                  will be backed by a `uuid[]` type in PostgreSQL.
                DESCRIPTION
              end

              # Common methods which are shared between fields
              import_shared :default
              import_shared :database_default
              import_shared :empty_array_to_null_coercion
              import_shared :unique_field
              import_shared :field_description
              import_shared :immutable_validators
              import_shared :remove_null_array_values_coercion
            end
          end
        end
      end
    end
  end
end
