# frozen_string_literal: true

module Platformer
  module Composers
    module Migrations
      class PrimaryKey < Parsers::Models
        for_dsl :primary_key, first_use_only: true do |skip:, table:, database:, reader:|
          # unless the skip: true option was set (in which case we are skipping the primary key)
          unless skip

            # update the dynamic documentation
            add_documentation <<~DESCRIPTION
              Add a column called `id` with type `uuid` to
              the `#{table.schema.name}'.'#{table.name}` table. This column can not
              be null, and defaults to gen_random_uuid().
            DESCRIPTION

            # add the column to the DynamicMigrations table
            column = table.add_column :id, :uuid, null: false, default: "gen_random_uuid()", description: <<~DESCRIPTION
              Standard primary key column
            DESCRIPTION

            # make the ID immutable
            database.make_column_immutable column

            # update the dynamic documentation
            add_documentation <<~DESCRIPTION
              Add a primary key constraint to the `#{table.schema.name}'.'#{table.name}`
              table which covers the colum `id`.
            DESCRIPTION

            # add the column to the DynamicMigrations table
            primary_key_name = :"#{table.name}_pkey"
            table.add_primary_key primary_key_name, [:id], description: <<~DESCRIPTION
              Standard primary key constraint
            DESCRIPTION

          end
        end
      end
    end
  end
end
