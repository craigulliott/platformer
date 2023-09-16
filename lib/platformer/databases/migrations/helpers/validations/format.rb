module Platformer
  module Databases
    class Migrations
      module Helpers
        module Validations
          module Format
            # this function is called from our custom DynamicMigrations template, it exists just to make the
            # generated migrations cleaner and easier to read
            def validate_format table_name, column_name, regexp, name: nil, comment: nil
              final_name = name || :"#{column_name}_format"

              final_comment = comment || Templates::Validations::Format::DEFAULT_COMMENT

              add_validation table_name, name: final_name, initially_deferred: false, deferrable: false, comment: final_comment do
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
