# frozen_string_literal: true

module Platformer
  module Composers
    module Migrations
      module Columns
        # Add all json columns to their respective tables within DynamicMigrations
        class Json < Parsers::FinalModels::ForFields
          for_field :json_field do |name:, table:, default:, comment_text:, allow_null:|
            # update the dynamic documentation
            add_documentation <<~DESCRIPTION
              Update DynamicMigrations and add a json column named `#{name}`
              to the `#{table.schema.name}'.'#{table.name}` table.
              #{allow_null ? "This column can be null." : ""}
            DESCRIPTION

            # add the column to the DynamicMigrations table
            table.add_column name, :jsonb, null: allow_null, default: default, description: comment_text
          end
        end
      end
    end
  end
end
