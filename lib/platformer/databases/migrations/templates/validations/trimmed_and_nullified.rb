module Platformer
  module Databases
    class Migrations
      module Templates
        module Validations
          class TrimmedAndNullified < DynamicMigrations::Postgres::Generator::ValidationTemplateBase
            DEFAULT_COMMENT = <<~COMMENT.strip
              This validation asserts that the trim_and_nullify coercion has been applied to this field.
            COMMENT

            warn "not tested"
            def fragment_arguments
              assert_not_deferred!
              assert_column_count! 1

              column_name = first_column.name
              options_string = name_and_description_options_string :"#{column_name}_trimmed_nullified", DEFAULT_COMMENT
              {
                schema: validation.table.schema,
                table: validation.table,
                migration_method: :add_validation,
                object: validation,
                code_comment: code_comment,
                migration: <<~RUBY
                  validate_trimmed_and_nullified :#{validation.table.name}, :#{column_name}#{options_string}
                RUBY
              }
            end
          end
        end
      end
    end
  end
end
