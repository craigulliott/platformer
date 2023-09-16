module Platformer
  module Databases
    class Migrations
      module Helpers
        module Validations
          module Inclusion
            # these functions are called from our custom DynamicMigrations template, it exists just to make the
            # generated migrations cleaner and easier to read
            def validate_in table_name, column_name, values, name: nil, comment: nil
              final_name = name || :"#{column_name}_in"
              final_comment = comment || Templates::Validations::Inclusion::DEFAULT_COMMENT
              add_validation table_name, name: final_name, initially_deferred: false, deferrable: false, comment: final_comment do
                "#{column_name} IN ('#{values.join("','")}')"
              end
            end
          end
        end
      end
    end
  end
end
