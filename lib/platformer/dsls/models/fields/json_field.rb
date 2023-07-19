module Platformer
  module DSLs
    module Models
      module Fields
        module JSONField
          def self.included klass
            klass.define_dsl :json_field do
              description "Add an json field to this model."

              add_method :empty_json_to_null do
                description <<-DESCRIPTION
                  Ensures that the value of this field can not be an empty json.
                  If it is an empty json, then it will be converted automatically
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
