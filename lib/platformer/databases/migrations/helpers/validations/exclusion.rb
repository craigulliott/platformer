module Platformer
  module Databases
    class Migrations
      module Helpers
        module Validations
          module Exclusion
            # these functions are called from our custom DynamicMigrations template, it exists just to make the
            # generated migrations cleaner and easier to read
            def validate_not_in table_name, column_name, values, name: nil, description: nil
              final_name = name || :"#{column_name}_not_in"
              final_description = description || Templates::Validations::Exclusion::DEFAULT_DESCRIPTION
              add_validation table_name, name: final_name, initially_deferred: false, deferrable: false, description: final_description do
                "#{column_name} NOT IN ('#{values.join("','")}')"
              end
            end
          end
        end
      end
    end
  end
end
