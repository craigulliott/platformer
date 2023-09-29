# frozen_string_literal: true

module Platformer
  module Composers
    module Migrations
      module Columns
        # Add all geo_point columns to their respective tables within DynamicMigrations
        class GeoPoint < Parsers::FinalModels::ForFields
          for_field :geo_point_field do |prefix:, database:, table:, array:, database_default:, description:, allow_null:|
            name_prepend = prefix.nil? ? "" : "#{prefix}_"
            name = :"#{name_prepend}lonlat"

            # update the dynamic documentation
            add_documentation <<~DESCRIPTION
              Add an #{array ? "array of geo point" : "geo point"}
              column named `#{name}` to the `#{table.schema.name}'.'#{table.name}` table.
              #{allow_null ? "This column can be null." : ""}
            DESCRIPTION

            # The data type of the column.
            data_type = array ? :"postgis.geography(Point,4326)[]" : :"postgis.geography(Point,4326)"

            # ensuure the postgis extension is installed
            database.ensure_postgres_extension :postgis

            # add the column to the DynamicMigrations table
            table.add_column name, data_type, null: allow_null, default: database_default, description: description
          end
        end
      end
    end
  end
end
