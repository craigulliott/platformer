# frozen_string_literal: true

module Platformer
  module Composers
    module Migrations
      module Coercions
        module Common
          # install validations to assert that the trim_and_nullify coercion rules were followed
          class TrimAndNullify < Parsers::FinalModels::ForFields
            for_string_fields do |name:, database:, table:, array:, default:, comment_text:, allow_null:|
              column = table.column name

              for_method :trim_and_nullify do |method_name:, comment:|
                add_documentation <<~DESCRIPTION
                  Update this models table (`#{column.table.schema.name}'.'#{column.table.name}`)
                  within DynamicMigrations and add a constraint to assert that any values provided
                  to the `#{column.name}` column have been trimmed and are not empty strings.
                DESCRIPTION

                validation_name = :"#{column.name}_trimmed_nullified"

                # if the column is an array, then we use a trigger and function to make the assertation
                if array
                  # install the required function (unless it has already been installed)
                  function = database.find_or_create_shared_function Functions::Validations::AssertArrayValuesTrimmedAndNullified

                  condition_sql = <<~SQL.strip
                    NEW.#{column.name} IS DISTINCT FROM OLD.#{column.name}
                  SQL
                  trigger_description = <<~DESCRIPTION
                    Will call the function and raise an exception if the column
                    contains any empty strings, or strings which have not had white
                    space trimmed from the start or end.
                  DESCRIPTION
                  [:insert, :update].each do |event_manipulation|
                    table.add_trigger :"#{column.name}_trim_null_on_#{event_manipulation}",
                      action_timing: :before,
                      event_manipulation: event_manipulation,
                      action_orientation: :row,
                      parameters: "'#{column.name}'",
                      action_condition: condition_sql,
                      function: function,
                      description: trigger_description
                  end

                # otherwise we use a check constraint
                else
                  # Add the validation to the table, assert that trimming and nullifying the
                  # provided value does not have any effect on the value (which asserts that
                  # it was properly trimmed and nullified before it was saved).
                  # It is safe to pass NULL to postgres' regexp_replace function.
                  check_clause = <<~SQL
                    #{column.name} IS DISTINCT FROM '' AND REGEXP_REPLACE(REGEXP_REPLACE(#{column.name}, '^\s+', ''), '\s+$', '') IS NOT DISTINCT FROM #{column.name}
                  SQL
                  table.add_validation validation_name, [column.name], check_clause, description: <<~COMMENT
                    #{comment}
                    This validation asserts that the trim_and_nullify coercion has been applied to this field
                  COMMENT
                end
              end
            end
          end
        end
      end
    end
  end
end
