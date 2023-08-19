# frozen_string_literal: true

module Platformer
  module Composers
    module Migrations
      module Coercions
        # install validations to assert that the trim_and_nullify coercion rules were followed
        class TrimAndNullifyCoercions < DSLCompose::Parser
          # Process the parser for every decendant of PlatformModel which does not have
          # it's own decendents. These represent Models which will have a coresponding
          # ActiveRecord class created for them, and thus a table within the database
          for_final_children_of PlatformModel do |child_class:|
            # the table structure object from DynamicMigrations, this was created and
            # the result cached within the CreateStructure parser
            table = ModelToTableStructure.get_table_structure child_class

            # for each field on this model which can have the trim_and_nullify_coercions
            for_dsl [:char_field, :text_field] do |array:, name:|
              # Get the coresponding column object from DynamicMigrations for this field
              column = table.column name

              for_method :trim_and_nullify do |method_name:, comment:|
                description <<~DESCRIPTION
                  Update this models table (`#{column.table.schema.name}'.'#{column.table.name}`)
                  within DynamicMigrations and add a constraint to assert that any values provided
                  to the `#{column.name}` column have been trimmed and are not empty strings.
                DESCRIPTION

                validation_name = :"#{column.name}_trimmed_nullified"

                # if the column is an array, then we use a trigger and function to make the assertation
                if array
                  function_name = :assert_array_column_trimmed_nullified
                  # install the required function (unless it has already been installed)
                  function = if table.schema.database.configured_schema(:public).has_function? function_name
                    table.schema.database.configured_schema(:public).function(function_name)
                  else
                    # the function definition and definitions
                    function_definition = AssertArrayValuesTrimmedAndNullified.definition
                    # create the function
                    table.schema.database.configured_schema(:public).add_function function_name, function_definition, description: <<~DESCRIPTION
                      A function which will be called from a table trigger when changes are attempted to
                      a column which contains an array of strings, and the corresponding field has a
                      trimm_and_nullify coercion on it. This function takes an argument which corresponds to the
                      column name, and will analyze the array in that column and assert that each value
                      has been properly trimmed and that the array does not contain any empty strings.
                    DESCRIPTION
                  end

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
