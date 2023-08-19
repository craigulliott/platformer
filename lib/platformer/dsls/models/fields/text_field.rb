module Platformer
  module DSLs
    module Models
      module Fields
        module TextField
          def self.included klass
            klass.define_dsl :text_field do
              description <<~DESCRIPTION
                Add a text field to this model. The text type can store text of
                a specific length.
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
              # denote this as an array of texts
              optional :array, :boolean do
                description <<~DESCRIPTION
                  If true, then this field will be an array of texts, and
                  will be backed by a `text[]` type in PostgreSQL.
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
              import_shared :field_comment
              import_shared :immutable_validators
              import_shared :case_coercions
              import_shared :trim_and_nullify_coercion
              import_shared :remove_null_array_values_coercion
            end
          end
        end
      end
    end
  end
end
