module Platformer
  module DSLs
    module Models
      module Fields
        module IpAddressField
          def self.included klass
            klass.define_dsl :ip_address_field do
              namespace :fields
              title "Add an IpAddress field to your Model"
              description "Add a field to this model for storing IPv4 and IPv6 ip addresses."

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
              # denote this as an array of inets
              optional :array, :boolean do
                description <<~DESCRIPTION
                  If true, then this field will be an array of inets, and
                  will be backed by a `inet[]` type in PostgreSQL.
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
              import_shared :remove_null_array_values_coercion
            end
          end
        end
      end
    end
  end
end
