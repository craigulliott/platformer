# frozen_string_literal: true

module Platformer
  module Databases
    module Postgres
      class Server
        class Database
          module Composers
            module MakeColumnImmutableOnceSet
              def make_column_immutable_once_set column
                table = column.table
                column_name = column.name

                condition_sql = <<~SQL
                  (
                    NEW.#{column_name} IS DISTINCT FROM OLD.#{column_name}
                    AND OLD.#{column_name} IS NOT NULL
                  )
                SQL

                trigger_name = :immutable_once_set

                # find and update, or create the immutable trigger for this table which will
                # raise an error if the column (or any of the previousely configured columns)
                # have been changed.
                if table.has_trigger? trigger_name
                  # the trigger already exists, which means another column is already using this function
                  # update the triggers parameters and action condition to include this column
                  trigger = table.trigger trigger_name
                  trigger.parameters = "#{trigger.parameters},'#{column_name}'"
                  trigger.action_condition = "#{trigger.action_condition} OR #{condition_sql}"
                else
                  function = find_or_create_shared_function Functions::Validations::ImmutableValidation

                  table.add_trigger trigger_name,
                    template: :immutable_once_set,
                    action_timing: :before,
                    event_manipulation: :update,
                    action_orientation: :row,
                    parameters: "'#{column_name}'",
                    action_condition: condition_sql,
                    function: function,
                    description: <<~DESCRIPTION
                      Will call the function and raise an exception if any of the columns in
                      the action_condition have been illegally updated.
                    DESCRIPTION
                end
              end
            end
          end
        end
      end
    end
  end
end
