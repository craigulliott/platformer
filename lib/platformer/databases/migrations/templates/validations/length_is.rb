module Platformer
  module Databases
    class Migrations
      module Templates
        module Validations
          class LengthIs < DynamicMigrations::Postgres::Generator::ValidationTemplateBase
            DEFAULT_COMMENT = <<~COMMENT.strip
              This validation asserts that the string length is exactly the given value
            COMMENT

            VALUE_FROM_CHECK_CLAUSE = /
              \A # start of string
              \(? # optional opening parenthesis around the whole check clause
              LENGTH\( # length function which takes a column name
              "? # optional opening quote around the column name
              \w+ # the column name
              "? # optional opening quote around the column name
              \) # closing parenthesis around the length function
              \s # whitespace
              = # equals comparitor part of the check clause
              \s # whitespace
              (?<value> # named capture group
              -? # optional negative sign for a negative number
              \d+ # the integer part of the number
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
              options_string = name_and_description_options_string :"#{column_name}_length", DEFAULT_COMMENT
              {
                schema: validation.table.schema,
                table: validation.table,
                migration_method: :add_validation,
                object: validation,
                code_comment: code_comment,
                migration: <<~RUBY
                  validate_length_is :#{validation.table.name}, :#{column_name}, #{value}#{options_string}
                RUBY
              }
            end
          end
        end
      end
    end
  end
end
