module Platformer
  module Databases
    class Migrations
      module Triggers
        module TrimmedAndNullifiedArray
          warn "todo"
          def trimmed_and_nullified_array table_name, column_name, name: nil, comment: nil
            before_insert :users, name: :uppercase_names_trim_null_on_insert, function_schema_name: :platformer, function_name: :platformer_databases_postgres_functions_validations_assert_array_values_trimmed_and_nullified, action_condition: "NEW.uppercase_names IS DISTINCT FROM OLD.uppercase_names", parameters: "'uppercase_names'", comment: <<~COMMENT
              Will call the function and raise an exception if the column
              contains any empty strings, or strings which have not had white
              space trimmed from the start or end.
            COMMENT

            before_update :users, name: :uppercase_names_trim_null_on_update, function_schema_name: :platformer, function_name: :platformer_databases_postgres_functions_validations_assert_array_values_trimmed_and_nullified, action_condition: "NEW.uppercase_names IS DISTINCT FROM OLD.uppercase_names", parameters: "'uppercase_names'", comment: <<~COMMENT
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
