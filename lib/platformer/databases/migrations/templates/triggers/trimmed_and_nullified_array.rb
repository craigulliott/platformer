module Platformer
  module Databases
    class Migrations
      module Templates
        module Triggers
          class TrimmedAndNullifiedArray < DynamicMigrations::Postgres::Generator::TriggerTemplateBase
            warn "not tested"
            def fragment_arguments
              column_name = trigger.parameters
              {
                schema: trigger.table.schema,
                table: trigger.table,
                migration_method: :add_trigger,
                object: trigger,
                code_comment: code_comment,
                migration: <<~RUBY
                  trimmed_and_nullified_array :#{trigger.table.name}, #{column_name}
                RUBY
              }
            end
          end
        end
      end
    end
  end
end
