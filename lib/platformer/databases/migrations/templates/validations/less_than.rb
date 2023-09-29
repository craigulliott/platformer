module Platformer
  module Databases
    class Migrations
      module Templates
        module Validations
          class LessThan < DynamicMigrations::Postgres::Generator::ValidationTemplateBase
            DEFAULT_DESCRIPTION = <<~DESCRIPTION.strip
              This validation asserts that the column value is less than the provided value
            DESCRIPTION

            VALUE_FROM_CHECK_CLAUSE = /
              \A # start of string
              \(? # optional opening parenthesis around the whole check clause
              "? # optional opening quote around the column name
              \w+ # the column name
              "? # optional opening quote around the column name
              \s # whitespace
              < # less than
              \s # whitespace
              (?<value> # named capture group
              -? # optional negative sign for a negative number
              \d+ # the integer part of the number
              (?:\.\d+)? # optional decimal part of the number
              ) # close capture group
              \)? # optional closing parenthesis around the whole check clause
              \z # end of string
            /x

            warn "not tested"
            def fragment_arguments
              assert_not_deferred!
              assert_column_count! 1

              column_name = first_column.name
              value = value_from_check_clause(VALUE_FROM_CHECK_CLAUSE)
              options_string = name_and_description_options_string :"#{column_name}_lt", DEFAULT_DESCRIPTION
              {
                schema: validation.table.schema,
                table: validation.table,
                migration_method: :add_validation,
                object: validation,
                code_description: code_description,
                migration: <<~RUBY
                  validate_less_than :#{validation.table.name}, :#{column_name}, #{value}#{options_string}
                RUBY
              }
            end
          end
        end
      end
    end
  end
end
