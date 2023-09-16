module Platformer
  module Databases
    class Migrations
      module Templates
        module Validations
          class IsValue < DynamicMigrations::Postgres::Generator::ValidationTemplateBase
            DEFAULT_COMMENT = <<~COMMENT.strip
              This validation asserts that the column value matches the provided value
            COMMENT

            warn "not tested"
            def fragment_arguments
              assert_not_deferred!
              assert_column_count! 1

              column_name = first_column.name
              value = value_from_check_clause(/\A\w+ = '(?<value>.+)'\z/)
              options_string = name_and_description_options_string :"#{column_name}_is", DEFAULT_COMMENT
              {
                schema: validation.table.schema,
                table: validation.table,
                migration_method: :add_validation,
                object: validation,
                code_comment: code_comment,
                migration: <<~RUBY
                  validate_is :#{validation.table.name}, :#{column_name}, "#{value}"#{options_string}
                RUBY
              }
            end
          end
        end
      end
    end
  end
end
