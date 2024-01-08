module Platformer
  module Databases
    class Migrations
      module Templates
        module Triggers
          class TrimmedAndNullifiedArray < DynamicMigrations::Postgres::Generator::TriggerTemplateBase
            # todo: not tested
            def fragment_arguments
              # this trigger will be called before `insert` and `update`, but is only created once
              # here because the convenience method `trimmed_and_nullified_array` will set up both
              # types of trigger
              if trigger.event_manipulation == :insert
                column_name = trigger.parameters.first
                {
                  schema: trigger.table.schema,
                  table: trigger.table,
                  migration_method: :add_trigger,
                  object: trigger,
                  code_comment: code_comment,
                  migration: <<~RUBY
                    trimmed_and_nullified_array :#{trigger.table.name}, :#{column_name}
                  RUBY
                }
              end
            end
          end
        end
      end
    end
  end
end
