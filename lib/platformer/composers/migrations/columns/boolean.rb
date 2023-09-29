# frozen_string_literal: true

module Platformer
  module Composers
    module Migrations
      module Columns
        # Add all boolean columns to their respective tables within DynamicMigrations
        class Boolean < Parsers::FinalModels::ForFields
          for_field :boolean_field do |name:, table:, array:, database_default:, description:, allow_null:|
            add_documentation <<~DESCRIPTION
              Add an #{array ? "array of booleans" : "boolean"}
              column named `#{name}` to the `#{table.schema.name}'.'#{table.name}` table.
              #{allow_null ? "This column can be null." : ""}
            DESCRIPTION

            # The data type of the column.
            data_type = array ? :"boolean[]" : :boolean

            # add the column to the DynamicMigrations table
            table.add_column name, data_type, null: allow_null, default: database_default, description: description
          end
        end
      end
    end
  end
end
