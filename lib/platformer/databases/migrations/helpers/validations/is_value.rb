module Platformer
  module Databases
    class Migrations
      module Helpers
        module Validations
          module IsValue
            # this function is called from our custom DynamicMigrations template, it exists just to make the
            # generated migrations cleaner and easier to read
            def validate_is table_name, column_name, value, name: nil, comment: nil
              final_name = name || :"#{column_name}_is"

              final_comment = comment || Templates::Validations::IsValue::DEFAULT_COMMENT

              add_validation table_name, name: final_name, initially_deferred: false, deferrable: false, comment: final_comment do
                <<~SQL
                  #{column_name} = '#{value}'
                SQL
              end
            end
          end
        end
      end
    end
  end
end
