# frozen_string_literal: true

module Platformer
  module Composers
    module Migrations
      module Columns
        # Add all uuid columns to their respective tables within DynamicMigrations
        class UuidColumns < Parsers::FinalModels::ForFields
          for_field :uuid_field do |name:, table:, array:, default:, comment_text:, allow_null:|
            # update the dynamic documentation
            description <<~DESCRIPTION
              Update DynamicMigrations and add an #{array ? "array of uuids" : "uuid"}
              column named `#{name}` to the `#{table.schema.name}'.'#{table.name}` table.
              #{allow_null ? "This column can be null." : ""}
            DESCRIPTION

            # The data type of the column.
            data_type = array ? :"uuid[]" : :uuid

            # add the column to the DynamicMigrations table
            table.add_column name, data_type, null: allow_null, default: default, description: comment_text
          end
        end
      end
    end
  end
end
