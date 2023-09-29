module Platformer
  module Databases
    class Migrations
      module Helpers
        module Triggers
          module Immutable
            def immutable table_name, column_names
              action_condition = column_names.map { |column_name| "NEW.#{column_name} IS DISTINCT FROM OLD.#{column_name}" }.join(" OR ")
              before_update table_name, name: :immutable, function_schema_name: :platformer, function_name: :validations_immutable, action_condition: action_condition, parameters: column_names, description: <<~DESCRIPTION
                Will call the function and raise an exception if any of the immutable columns have been updated.
              DESCRIPTION
            end

            def immutable_once_set table_name, column_names
              action_condition = column_names.map { |column_name| "(NEW.#{column_name} IS DISTINCT FROM OLD.#{column_name} AND OLD.#{column_name} IS NOT NULL)" }.join(" OR ")

              before_update table_name, name: :immutable_once_set, function_schema_name: :platformer, function_name: :validations_immutable_once_set, action_condition: action_condition, parameters: column_names, description: <<~DESCRIPTION
                Will call the function and raise an exception if any of the immutable columns have been updated,
                unless they were just updated from NULL for the first time.
              DESCRIPTION
            end
          end
        end
      end
    end
  end
end
