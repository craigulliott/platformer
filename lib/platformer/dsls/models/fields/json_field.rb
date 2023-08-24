module Platformer
  module DSLs
    module Models
      module Fields
        module JsonField
          def self.included klass
            klass.define_dsl :json_field do
              description <<~DESCRIPTION
                Add a json field to this model.
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

              add_method :empty_json_to_null do
                description <<~DESCRIPTION
                  Ensures that the value of this field can not be an empty json object.
                  If it is an empty json object, then it will be converted automatically
                  to null. This coercion logic will be installed into active record,
                  the API and the database as a stored procedure.
                DESCRIPTION

                optional :comment, :string do
                  description <<~DESCRIPTION
                    A comment which explains the reason for adding coercing empty arrays
                    to null on this field. This will be used to generate documentation,
                    and will be added as a comment to the database constraint.
                  DESCRIPTION
                end
              end

              # Methods
              #
              add_unique_method :default do
                requires :default, :string
              end

              # Common methods which are shared between fields
              import_shared :allow_null
              import_shared :field_comment
              import_shared :immutable_validators
            end
          end
        end
      end
    end
  end
end
