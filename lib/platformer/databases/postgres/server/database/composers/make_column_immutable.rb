# frozen_string_literal: true

module Platformer
  module Databases
    module Postgres
      class Server
        class Database
          module Composers
            module MakeColumnImmutable
              def make_column_immutable column
                table = column.table
                column_name = column.name

                condition_sql = "NEW.#{column_name} IS DISTINCT FROM OLD.#{column_name}"

                trigger_name = :immutable

                # find and update, or create the immutable trigger for this table which will
                # raise an error if the column (or any of the previousely configured columns)
                # have been changed.
                if table.has_trigger? trigger_name
                  # the trigger already exists, which means another column is already using this function
                  # update the triggers parameters and action condition to include this column
                  trigger = table.trigger trigger_name
                  trigger.add_parameter column_name.to_s
                  trigger.action_condition = "#{trigger.action_condition} OR #{condition_sql}"
                else
                  function = find_or_create_shared_function Functions::Validations::Immutable

                  table.add_trigger trigger_name,
                    template: :immutable,
                    action_timing: :before,
                    event_manipulation: :update,
                    action_orientation: :row,
                    parameters: [column_name.to_s],
                    action_condition: condition_sql,
                    function: function,
                    description: <<~DESCRIPTION
                      Will call the function and raise an exception if any of the immutable columns have been updated.
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
