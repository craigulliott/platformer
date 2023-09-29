module Platformer
  module Databases
    class Migrations
      module Templates
        module Triggers
          class ImmutableOnceSet < DynamicMigrations::Postgres::Generator::TriggerTemplateBase
            warn "not tested"
            def fragment_arguments
              column_names = trigger.parameters
              {
                schema: trigger.table.schema,
                table: trigger.table,
                migration_method: :add_trigger,
                object: trigger,
                code_description: code_description,
                migration: <<~RUBY
                  immutable_once_set :#{trigger.table.name}, [:#{column_names.join(", :")}]
                RUBY
              }
            end
          end
        end
      end
    end
  end
end
