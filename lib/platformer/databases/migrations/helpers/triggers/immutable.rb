module Platformer
  module Databases
    class Migrations
      module Triggers
        module Immutable
          def immutable_columns table_name, column_names
            action_condition = column_names.map { |column_name| "NEW.#{column_name} IS DISTINCT FROM OLD.#{column_name}" }.join(" OR ")
            parameters = "'#{column_names.join("','")}'"

            before_update table_name, name: :immutable, function_schema_name: :platformer, function_name: :immutable_validation, action_condition: action_condition, parameters: parameters, comment: <<~COMMENT
              Will call the function and raise an exception if any of the columns #{column_names.join(", ")}
              have been updated.
            COMMENT
          end

          def immutable_once_set_columns table_name, column_names
            action_condition = column_names.map { |column_name| "(NEW.#{column_name} IS DISTINCT FROM OLD.#{column_name} AND OLD.#{column_name} IS NOT NULL)" }.join(" OR ")
            parameters = "'#{column_names.join("','")}'"

            before_update table_name, name: :immutable_once_set, function_schema_name: :platformer, function_name: :immutable_once_set_validation, action_condition: action_condition, parameters: parameters, comment: <<~COMMENT
              Will call the function and raise an exception if any of the columns #{column_names.join(", ")}
              have been updated, unless they were just updated from NULL for the first time.
            COMMENT
          end
        end
      end
    end
  end
end
