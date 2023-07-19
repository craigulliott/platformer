module Platformer
  module DSLs
    module Models
      module Fields
        module ArrayField
          def self.included klass
            klass.define_dsl :array_field do
              description "Add an array field to this model."

              add_method :empty_array_to_null do
                description <<-DESCRIPTION
                  Ensures that the value of this field can not be an empty array.
                  If it is an empty array, then it will be converted automatically
                  to null. This coercion logic will be installed into active record,
                  the API and the database as a stored procedure.
                DESCRIPTION
              end
            end
          end
        end
      end
    end
  end
end
