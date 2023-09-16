module Platformer
  module Databases
    class Migrations
      module Helpers
        module Validations
          module ZeroNulled
            # this function is called from our custom DynamicMigrations template, it exists just to make the
            # generated migrations cleaner and easier to read
            def validate_zero_nulled table_name, column_name, name: nil, comment: nil
              final_name = name || :"#{column_name}_zero_nulled"

              final_comment = comment || Templates::Validations::ZeroNulled::DEFAULT_COMMENT

              add_validation table_name, name: final_name, initially_deferred: false, deferrable: false, comment: final_comment do
                <<~SQL
                  #{column_name} IS DISTINCT FROM 0
                SQL
              end
            end
          end
        end
      end
    end
  end
end
