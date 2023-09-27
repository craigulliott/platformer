module Platformer
  module DSLs
    module Models
      module Fields
        module DateField
          def self.included klass
            klass.define_dsl :date_field do
              namespace :fields
              title "Add a Date field to your Model"
              description <<~DESCRIPTION
                Add a date field to this model.
              DESCRIPTION

              # Arguments
              #
              # the name of the field
              requires :name, :symbol do
                description "The name of your field."
                import_shared :field_name_validators
              end

              # add an optional attribute which can be used to
              # denote this as an array of dates
              optional :array, :boolean do
                description <<~DESCRIPTION
                  If true, then this field will be an array of dates, and
                  will be backed by a `date(length)[]` type in PostgreSQL.
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
              import_shared :field_description
              import_shared :immutable_validators
              import_shared :date_validators
              import_shared :remove_null_array_values_coercion
            end
          end
        end
      end
    end
  end
end
