module Platformer
  module Databases
    class Migrations
      module Templates
        module Validations
          class Uppercase < DynamicMigrations::Postgres::Generator::ValidationTemplateBase
            warn "not tested"
            def fragment_arguments
              assert_not_deferred!
              assert_column_count! 1

              column_name = first_column.name
              options_string = name_and_description_options_string :"#{column_name}_uppercase_only"
              if first_column.array?
                options_string = ", array: true#{options_string}"
              end

              {
                schema: validation.table.schema,
                table: validation.table,
                migration_method: :add_validation,
                object: validation,
                code_comment: code_comment,
                migration: <<~RUBY
                  validate_uppercase :#{validation.table.name}, :#{column_name}#{options_string}
                RUBY
              }
            end
          end
        end
      end
    end
  end
end
