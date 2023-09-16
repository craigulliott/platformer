module Platformer
  module Databases
    class Migrations
      module Templates
        module Validations
          class ZeroNulled < DynamicMigrations::Postgres::Generator::ValidationTemplateBase
            DEFAULT_COMMENT = <<~COMMENT.strip
              This validation asserts that the zero_to_null coercion has been applied to this field
            COMMENT

            warn "not tested"
            def fragment_arguments
              assert_not_deferred!
              assert_column_count! 1

              column_name = first_column.name
              options_string = name_and_description_options_string :"#{column_name}_zero_nulled", DEFAULT_COMMENT
              {
                schema: validation.table.schema,
                table: validation.table,
                migration_method: :add_validation,
                object: validation,
                code_comment: code_comment,
                migration: <<~RUBY
                  validate_zero_nulled :#{validation.table.name}, :#{column_name}#{options_string}
                RUBY
              }
            end
          end
        end
      end
    end
  end
end
