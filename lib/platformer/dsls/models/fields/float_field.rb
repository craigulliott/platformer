module Platformer
  module DSLs
    module Models
      module Fields
        module FloatField
          def self.included klass
            klass.define_dsl :float_field do
              description "Add a float field to this model."

              # the name of the field
              requires :name, :symbol do
                description "The name of this float field"
                import_shared :field_name_validators
              end

              import_shared :allow_null

              import_shared :immutable_validators
              import_shared :numeric_validators
            end
          end
        end
      end
    end
  end
end
