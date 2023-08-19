# frozen_string_literal: true

module Platformer
  module Composers
    module Migrations
      module Validations
        module Common
          # Install immutable validations for the respective columns within DynamicMigrations
          class ImmutableValidations < DSLCompose::Parser
            # Process the parser for every decendant of PlatformModel which does not have
            # it's own decendents. These represent Models which will have a coresponding
            # ActiveRecord class created for them, and thus a table within the database
            for_final_children_of PlatformModel do |child_class:|
              # the table structure object from DynamicMigrations, this was created and
              # the result cached within the CreateStructure parser
              table = ModelToTableStructure.get_table_structure child_class

              # for each field type which includes the common immutable validations
              for_dsl_or_inherited_dsl [
                :boolean_field,
                :char_field,
                :citext_field,
                :date_field,
                :date_time_field,
                :double_field,
                :email_field,
                :enum_field,
                :float_field,
                :integer_field,
                :json_field,
                :numeric_field,
                :phone_number_field,
                :text_field
              ] do |name:|
                # Get the coresponding column object from DynamicMigrations for this field
                column = table.column name

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

                  function_name = once_set ? :platformer_immutable_once_set_validation : :platformer_immutable_validation

                  # install the immutable function (unless it has already been installed)
                  function = if table.schema.database.configured_schema(:public).has_function? function_name
                    table.schema.database.configured_schema(:public).function(function_name)
                  else
                    # the function definition and definitions
                    function_definition = ImmutableFunctionDefinition.definition once_set
                    # create the function
                    table.schema.database.configured_schema(:public).add_function function_name, function_definition, description: <<~DESCRIPTION
                      A function which will be called from a table trigger when changes are attempted to
                      be made to columns which have been marked as immutable. This function takes all the
                      immutable column names as string arguments, checks which collumns have been illegally
                      changed and then raises a descriptive error.
                    DESCRIPTION
                  end

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
end
