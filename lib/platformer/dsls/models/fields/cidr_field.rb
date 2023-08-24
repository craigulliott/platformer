module Platformer
  module DSLs
    module Models
      module Fields
        module CidrField
          def self.included klass
            klass.define_dsl :cidr_field do
              description <<~DESCRIPTION
                Add a field to this model for storing IPv4 or IPv6 network
                specifications, such as `192.168.0.0/24` or
                '2001:4f8:3:ba::/64'.
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
              # denote this as an array of cidrs
              optional :array, :boolean do
                description <<~DESCRIPTION
                  If true, then this field will be an array of cidrs, and
                  will be backed by a `cidr[]` type in PostgreSQL.
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
              import_shared :immutable_validators
              import_shared :remove_null_array_values_coercion
            end
          end
        end
      end
    end
  end
end
