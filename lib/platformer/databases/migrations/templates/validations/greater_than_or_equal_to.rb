module Platformer
  module Databases
    class Migrations
      module Templates
        module Validations
          class GreaterThanOrEqualTo < DynamicMigrations::Postgres::Generator::ValidationTemplateBase
            DEFAULT_DESCRIPTION = <<~DESCRIPTION.strip
              This validation asserts that the column value is greater than or equal to the provided value
            DESCRIPTION

            VALUE_FROM_CHECK_CLAUSE = /
              \A # start of string
              \(? # optional opening parenthesis around the whole check clause
              \(? # optional opening parenthesis around the column name
              "? # optional opening quote around the column name
              \w+ # the column name
              "? # optional closing quote around the column name
              \)? # optional closing parenthesis around the column name
              \s # whitespace
              >= # greater than or equal to
              \s # whitespace
              \(? # optional opening parenthesis around the value
              (?<value> # named capture group
              -? # optional negative sign for a negative number
              \d+ # the integer part of the number
              (?:\.\d+)? # optional decimal part of the number
              ) # close capture group
              \)? # optional closing parenthesis around the value
              (?:::numeric)? # optional cast
              \)? # optional closing parenthesis around the whole check clause
              \z # end of string
            /x

            # todo: not tested
            def fragment_arguments
              assert_column_count! 1

              column_name = first_column.name
              value = value_from_check_clause(VALUE_FROM_CHECK_CLAUSE)
              options_string = name_and_description_options_string :"#{column_name}_gte", DEFAULT_DESCRIPTION
              {
                schema: validation.table.schema,
                table: validation.table,
                migration_method: :add_validation,
                object: validation,
                code_comment: code_comment,
                migration: <<~RUBY
                  validate_greater_than_or_equal_to :#{validation.table.name}, :#{column_name}, #{value}#{options_string}
                RUBY
              }
            end
          end
        end
      end
    end
  end
end
