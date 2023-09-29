# frozen_string_literal: true

module Platformer
  module Composers
    module Migrations
      module Columns
        # Add all citext columns to their respective tables within DynamicMigrations
        class Citext < Parsers::FinalModels::ForFields
          for_field :citext_field do |name:, table:, database:, array:, database_default:, description:, allow_null:|
            # update the dynamic documentation
            add_documentation <<~DESCRIPTION
              Add an #{array ? "array of citexts" : "citext"}
              column named `#{name}` to the `#{table.schema.name}'.'#{table.name}` table.
              #{allow_null ? "This column can be null." : ""}
            DESCRIPTION

            # The data type of the column.
            data_type = array ? :"citext[]" : :citext

            # ensuure the citext extension is installed
            database.ensure_postgres_extension :citext

            # add the column to the DynamicMigrations table
            table.add_column name, data_type, null: allow_null, default: database_default, description: description
          end
        end
      end
    end
  end
end
