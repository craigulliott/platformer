module Platformer
  module Databases
    class Migrations
      module Templates
        module Triggers
          class Immutable < DynamicMigrations::Postgres::Generator::TriggerTemplateBase
            # todo: not tested
            def fragment_arguments
              column_names = trigger.parameters
              {
                schema: trigger.table.schema,
                table: trigger.table,
                migration_method: :add_trigger,
                object: trigger,
                code_comment: code_comment,
                migration: <<~RUBY
                  immutable :#{trigger.table.name}, [:#{column_names.join(", :")}]
                RUBY
              }
            end
          end
        end
      end
    end
  end
end
