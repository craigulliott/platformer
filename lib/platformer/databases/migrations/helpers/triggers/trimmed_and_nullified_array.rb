module Platformer
  module Databases
    class Migrations
      module Helpers
        module Triggers
          module TrimmedAndNullifiedArray
            def trimmed_and_nullified_array table_name, column_name, name: nil, comment: nil
              final_name = name || :"#{column_name}_trim_null"
              before_insert table_name, name: :"#{final_name}_on_insert", function_schema_name: :platformer, function_name: :validations_assert_array_values_trimmed_and_nullified, parameters: [column_name], comment: <<~COMMENT
                Will call the function and raise an exception if the column
                contains any empty strings, or strings which have not had white
                space trimmed from the start or end.
              COMMENT

              condition_sql = <<~SQL.strip
                NEW.#{column_name} IS DISTINCT FROM OLD.#{column_name} AND NEW.#{column_name} IS NOT NULL
              SQL

              before_update table_name, name: :"#{final_name}_on_update", function_schema_name: :platformer, function_name: :validations_assert_array_values_trimmed_and_nullified, action_condition: condition_sql, parameters: [column_name], comment: <<~COMMENT
                Will call the function and raise an exception if the column
                contains any empty strings, or strings which have not had white
                space trimmed from the start or end.
              COMMENT
            end
          end
        end
      end
    end
  end
end
