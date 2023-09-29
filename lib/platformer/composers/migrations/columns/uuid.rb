# frozen_string_literal: true

module Platformer
  module Composers
    module Migrations
      module Columns
        # Add all uuid columns to their respective tables within DynamicMigrations
        class Uuid < Parsers::FinalModels::ForFields
          for_field :uuid_field do |name:, table:, array:, database_default:, description:, allow_null:|
            # update the dynamic documentation
            add_documentation <<~DESCRIPTION
              Add an #{array ? "array of uuids" : "uuid"}
              column named `#{name}` to the `#{table.schema.name}'.'#{table.name}` table.
              #{allow_null ? "This column can be null." : ""}
            DESCRIPTION

            # The data type of the column.
            data_type = array ? :"uuid[]" : :uuid

            # add the column to the DynamicMigrations table
            table.add_column name, data_type, null: allow_null, default: database_default, description: description
          end
        end
      end
    end
  end
end
