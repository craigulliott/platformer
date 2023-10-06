# frozen_string_literal: true

module Platformer
  module Composers
    module Migrations
      class SoftDeletable < Parsers::Models
        for_dsl :soft_deletable do |schema:, table:|
          # update the dynamic documentation
          add_documentation <<~DESCRIPTION
            Add a boolean column named `undeleted` and a timestamp column named
            `deleted_at` to the `#{table.schema.name}'.'#{table.name}` table.
            These columns represent soft deletion functionality for this model.
          DESCRIPTION

          # add the boolean to the DynamicMigrations table
          table.add_column :undeleted, :boolean, null: true, description: <<~DESCRIPTION
            This column is true before the delete has occured on this model, and will
            be set to NULL after the delete has occured.
          DESCRIPTION

          # add the timestamp to the DynamicMigrations table
          table.add_column :deleted_at, :"timestamp without time zone", null: true, description: <<~DESCRIPTION
            This column is NULL before the delete has occured on this model, and will
            be set to the current time when the delete occurs.
          DESCRIPTION

          validation_name = :soft_deletable
          # add the validation to the table
          check_clause = <<~SQL
            (undeleted IS NULL AND deleted_at IS NOT NULL)
            OR (undeleted IS TRUE AND deleted_at IS NULL)
          SQL
          table.add_validation validation_name, [:undeleted, :deleted_at], check_clause, deferrable: false, initially_deferred: false
        end
      end
    end
  end
end
