module Platformer
  module DSLs
    module Models
      module Fields
        module IntegerField
          def self.included klass
            klass.define_dsl :integer_field do
              description "Add an integer field to this model."

              # Arguments
              #
              # the name of the field
              requires :name, :symbol do
                description "The name of your field."
                import_shared :field_name_validators
              end
              # add the allow_null optional argument
              import_shared :allow_null

              # Methods
              #
              add_method :unique do
                optional :comment, :string
              end

              # Common methods which are shared between fields
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
