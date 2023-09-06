# frozen_string_literal: true

module Platformer
  module Composers
    module Migrations
      class ActionField < Parsers::FinalModels
        class MissingStatesError < StandardError
        end

        for_dsl :action_field do |name:, action_name:, schema:, table:, comment:|
          boolean_column_name = :"un#{name}"
          timestamp_column_name = :"#{name}_at"

          # update the dynamic documentation
          add_documentation <<~DESCRIPTION
            Update DynamicMigrations and add a boolean column named `#{boolean_column_name}`
            and a timestamp column named `#{timestamp_column_name}` to the
            `#{table.schema.name}'.'#{table.name}` table. These columns are used to represent
            an action_field for this model.
          DESCRIPTION

          # add the boolean to the DynamicMigrations table
          boolean_column = table.add_column boolean_column_name, :boolean, null: true, description: <<~COMMENT
            #{comment}
            This column is true before the action `#{action_name}` has occured on this model, and will
            be set to NULL after the action has occured.
          COMMENT

          # add the timestamp to the DynamicMigrations table
          timestamp_column = table.add_column timestamp_column_name, :timestamp, null: true, description: <<~COMMENT
            #{comment}
            This column is NULL before the action `#{action_name}` has occured on this model, and will
            be set to the current time when the action occurs.
          COMMENT

          validation_name = :"#{name}_action_field"
          # add the validation to the table
          check_clause = <<~SQL
            (#{boolean_column.name} IS NULL AND #{timestamp_column.name} IS NOT NULL)
            OR (#{boolean_column.name} IS TRUE AND #{timestamp_column.name} IS NULL)
          SQL
          table.add_validation validation_name, [boolean_column.name, timestamp_column.name], check_clause, deferrable: false, initially_deferred: false, description: comment
        end
      end
    end
  end
end
