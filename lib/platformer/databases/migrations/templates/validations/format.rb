module Platformer
  module Databases
    class Migrations
      module Templates
        module Validations
          class Format < DynamicMigrations::Postgres::Generator::ValidationTemplateBase
            DEFAULT_DESCRIPTION = <<~DESCRIPTION.strip
              This validation asserts that the column value matches the provided regexp
            DESCRIPTION

            VALUE_FROM_CHECK_CLAUSE = /
              \A # start of string
              \(? # optional opening parenthesis around the whole check clause
              \(? # optional opening parenthesis around the column name
              "? # optional opening quote around the column name
              \w+ # the column name
              "? # optional closing quote around the column name
              \)? # optional closing parenthesis around the column name
              (?:::text)? # optional cast to text after the column name
              \s # whitespace
              ~ # regex comparitor part of the check clause
              \s # whitespace
              ' # opening single quote around the regex
              (?<value> # named capture group
              .+ # the regex
              ) # close capture group
              ' # closing single quote around the regex
              (?:::citext)? # optional cast to citext after the regex
              (?:::text)? # optional cast to text after the regex
              \)? # optional closing parenthesis around the whole check clause
              \z # end of string
            /x

            warn "not tested"
            def fragment_arguments
              assert_not_deferred!
              assert_column_count! 1

              column_name = first_column.name
              value = value_from_check_clause(VALUE_FROM_CHECK_CLAUSE)
              options_string = name_and_description_options_string :"#{column_name}_format", DEFAULT_DESCRIPTION
              {
                schema: validation.table.schema,
                table: validation.table,
                migration_method: :add_validation,
                object: validation,
                code_comment: code_comment,
                migration: <<~RUBY
                  validate_format :#{validation.table.name}, :#{column_name}, /#{value}/#{options_string}
                RUBY
              }
            end
          end
        end
      end
    end
  end
end
