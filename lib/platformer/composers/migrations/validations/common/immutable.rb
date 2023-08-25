# frozen_string_literal: true

module Platformer
  module Composers
    module Migrations
      module Validations
        module Common
          # Install immutable validations for the respective columns within DynamicMigrations
          class Immutable < Parsers::FinalModels::ForFields
            for_all_fields except: :phone_number do |name:, database:, table:, column:, array:, default:, comment_text:, allow_null:|
              # if the validate_greater_than validation was used
              for_method [:immutable, :immutable_once_set] do |method_name:|
                # "once set" is a slight variation on the immutable validation, where the
                # validation is not enforced until the first time the value changes away from null
                once_set = method_name == :immutable_once_set

                description <<~DESCRIPTION
                  Add a trigger to this table (`#{column.table.schema.name}'.'#{column.table.name}`)
                  and call a function which prevents the value of `#{name}` from
                  #{once_set ? " being updated after it has been first set to a value (meaning,
                  if it was created with the value of null, then it can be updated in the future
                  to a non value, but at that point the value can never be updated again)." : "ever being updated"}.
                DESCRIPTION

                # install the immutable function (unless it has already been installed)
                function_definition = once_set ? Functions::Validations::ImmutableOnceSetValidation : Functions::Validations::ImmutableValidation
                function = database.find_or_create_shared_function function_definition

                trigger_name = once_set ? :immutable_once_set : :immutable

                condition_sql = <<~SQL.strip
                  NEW.#{column.name} IS DISTINCT FROM OLD.#{column.name}
                SQL
                if once_set
                  condition_sql = <<~SQL.strip
                    (#{condition_sql} AND OLD.#{column.name} IS NOT NULL)
                  SQL
                end

                # find and update, or create the immutable trigger for this table which will
                # raise an error if the column (or any of the previousely configured columns)
                # have been changed.
                if table.has_trigger? trigger_name
                  # the trigger already exists, which means another column is already using this function
                  # update the triggers parameters and action condition to include this column
                  trigger = table.trigger trigger_name
                  trigger.parameters = "#{trigger.parameters},'#{column.name}'"
                  trigger.action_condition = "#{trigger.action_condition} OR #{condition_sql}"
                else
                  table.add_trigger trigger_name,
                    action_timing: :before,
                    event_manipulation: :update,
                    action_orientation: :row,
                    parameters: "'#{column.name}'",
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
