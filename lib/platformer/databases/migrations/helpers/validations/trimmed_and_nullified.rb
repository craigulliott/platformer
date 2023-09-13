module Platformer
  module Databases
    class Migrations
      module Validations
        module TrimmedAndNullified
          # this function is called from our custom DynamicMigrations template, it exists just to make the
          # generated migrations cleaner and easier to read
          def validate_trimmed_and_nullified table_name, column_name, name: nil, comment: nil
            final_name = name || :"#{column_name}_trimmed_nullified"

            final_comment = <<~COMMENT
              #{comment}
              This validation asserts that the trim_and_nullify coercion has been applied to this field.
            COMMENT

            add_validation table_name, name: final_name, initially_deferred: false, deferrable: false, comment: final_comment do
              <<~SQL
                #{column_name} IS DISTINCT FROM '' AND REGEXP_REPLACE(REGEXP_REPLACE(#{column_name}, '^ +', ''), ' +$', '') IS NOT DISTINCT FROM #{column_name};
              SQL
            end
          end
        end
      end
    end
  end
end
