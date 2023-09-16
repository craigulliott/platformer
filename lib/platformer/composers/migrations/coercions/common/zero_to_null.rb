# frozen_string_literal: true

module Platformer
  module Composers
    module Migrations
      module Coercions
        module Common
          # install validations to assert that the zero_to_null coercion rules were followed
          class ZeroToNull < Parsers::FinalModels::ForFields
            for_numeric_fields do |name:, table:, array:, default:, comment_text:, allow_null:|
              column = table.column name

              for_method :zero_to_null do |method_name:, comment:|
                add_documentation <<~DESCRIPTION
                  Update this models table (`#{column.table.schema.name}'.'#{column.table.name}`)
                  within DynamicMigrations and add a constraint to assert that the `#{column.name}`
                  column does not #{array ? "contain any values of 0" : "equal 0"}. This is
                  because this field has a zero_to_null coercion on it, so any 0's should have
                  been converted to null before saving.
                DESCRIPTION

                validation_name = :"#{column.name}_zero_nulled"

                final_comment = comment || Databases::Migrations::Templates::Validations::ZeroNulled::DEFAULT_COMMENT

                # Add the validation to the table, assert that the value is not the
                # number 0, (which asserts that the zero_to_null coercion was properly
                # applied before it was saved).
                check_clause = array ? "0 = ANY(#{column.name})" : "#{column.name} IS DISTINCT FROM 0"
                table.add_validation validation_name, [column.name], check_clause, template: :zero_nulled, description: final_comment
              end
            end
          end
        end
      end
    end
  end
end
