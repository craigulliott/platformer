module Platformer
  module Databases
    class Migrations
      module Validations
        module ZeroNulled
          # this function is called from our custom DynamicMigrations template, it exists just to make the
          # generated migrations cleaner and easier to read
          def validate_zero_nulled table_name, column_name, name: nil, comment: nil
            final_name = name || :"#{column_name}_zero_nulled"

            final_comment = <<~COMMENT
              #{comment}
              This validation asserts that the zero_to_null coercion has been applied to this field.
            COMMENT

            add_validation table_name, name: final_name, initially_deferred: false, deferrable: false, comment: final_comment do
              <<~SQL
                #{column_name} IS DISTINCT FROM 0;
              SQL
            end
          end
        end
      end
    end
  end
end
