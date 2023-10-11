module Platformer
  module Databases
    class Migrations
      module Helpers
        module Validations
          module Format
            # this function is called from our custom DynamicMigrations template, it exists just to make the
            # generated migrations cleaner and easier to read
            def validate_format table_name, column_name, regexp, name: nil, description: nil
              final_name = name || :"#{column_name}_format"

              final_description = description || Templates::Validations::Format::DEFAULT_DESCRIPTION

              add_validation table_name, name: final_name, comment: final_description do
                <<~SQL
                  #{column_name} ~ '#{regexp}'
                SQL
              end
            end
          end
        end
      end
    end
  end
end
