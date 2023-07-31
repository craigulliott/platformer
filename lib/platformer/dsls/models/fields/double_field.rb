module Platformer
  module DSLs
    module Models
      module Fields
        module DoubleField
          def self.included klass
            klass.define_dsl :double_field do
              description "Add a double field to this model."

              # the name of the field
              requires :name, :symbol do
                description "The name of this double field"
                import_shared :field_name_validators
              end

              # add an optional attribute which can be used to
              # denote this as an array of doubles
              optional :array, :boolean do
                description <<-DESCRIPTION
                  If true, then this field will be an array of doubles, and
                  will be backed by a `double precision[]` type in PostgreSQL.
                DESCRIPTION
              end

              # Methods
              #
              add_unique_method :default do
                requires :default, :float
              end

              # Common methods which are shared between fields
              import_shared :allow_null
              import_shared :unique_field
              import_shared :field_comment
              import_shared :immutable_validators
              import_shared :numeric_validators
            end
          end
        end
      end
    end
  end
end
