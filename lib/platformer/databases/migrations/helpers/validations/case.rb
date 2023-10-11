module Platformer
  module Databases
    class Migrations
      module Helpers
        module Validations
          module Case
            # these functions are called from our custom DynamicMigrations template, it exists just to make the
            # generated migrations cleaner and easier to read
            def validate_uppercase table_name, column_name, array: false, name: nil, description: nil
              final_name = name || :"#{column_name}_uppercase_only"

              check_clause = if array
                <<~SQL
                  #{column_name} IS NULL OR UPPER(ARRAY_REMOVE(#{column_name}, NULL)::text) IS NOT DISTINCT FROM ARRAY_REMOVE(#{column_name}, NULL)::text
                SQL
              else
                <<~SQL
                  #{column_name} IS NOT DISTINCT FROM UPPER(#{column_name})
                SQL
              end

              final_description = description || Templates::Validations::Uppercase::DEFAULT_DESCRIPTION

              add_validation table_name, name: final_name, comment: final_description do
                check_clause
              end
            end

            def validate_lowercase table_name, column_name, array: false, name: nil, description: nil
              final_name = name || :"#{column_name}_lowercase_only"

              check_clause = if array
                <<~SQL
                  #{column_name} IS NULL OR LOWER(ARRAY_REMOVE(#{column_name}, NULL)::text) IS NOT DISTINCT FROM ARRAY_REMOVE(#{column_name}, NULL)::text
                SQL
              else
                <<~SQL
                  #{column_name} IS NOT DISTINCT FROM LOWER(#{column_name})
                SQL
              end

              final_description = description || Templates::Validations::Uppercase::DEFAULT_DESCRIPTION

              add_validation table_name, name: final_name, comment: final_description do
                check_clause
              end
            end
          end
        end
      end
    end
  end
end
