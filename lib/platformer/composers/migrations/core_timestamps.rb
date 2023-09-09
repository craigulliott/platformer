# frozen_string_literal: true

module Platformer
  module Composers
    module Migrations
      class CoreTimestamps < Parsers::FinalModels
        warn "not tested"
        for_dsl :core_timestamps do |created_at:, updated_at:, database:, table:|
          #
          # the created_at timestamp
          #
          unless created_at == false
            # update the dynamic documentation
            add_documentation <<~DESCRIPTION
              And add a timestamp column named `created_at` with type `uuid` to the
              `#{table.schema.name}'.'#{table.name}` table. This column is can not be NULL.
            DESCRIPTION

            # add the column to the DynamicMigrations table
            column = table.add_column :created_at, :timestamp, null: false, description: <<~DESCRIPTION
              Should be set to the current time automatically when creating this record.
            DESCRIPTION

            # update the dynamic documentation
            add_documentation <<~DESCRIPTION
              Make the `created_at` column in `#{table.schema.name}'.'#{table.name}` immutable.
            DESCRIPTION

            # make the column immutable
            database.make_column_immutable column
          end

          #
          # the updated_at timestamp
          #
          unless updated_at == false
            # update the dynamic documentation
            add_documentation <<~DESCRIPTION
              And add a timestamp column named `updated_at` with type `uuid` to the
              `#{table.schema.name}'.'#{table.name}` table. This column can not be NULL.
            DESCRIPTION

            # add the column to the DynamicMigrations table
            table.add_column :updated_at, :timestamp, null: false, description: <<~DESCRIPTION
              Should be set to the current time automatically when creating this record.
            DESCRIPTION
          end
        end
      end
    end
  end
end
