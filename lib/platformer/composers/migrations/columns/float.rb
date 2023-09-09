# frozen_string_literal: true

module Platformer
  module Composers
    module Migrations
      module Columns
        # Add all float columns to their respective tables within DynamicMigrations
        class Float < Parsers::FinalModels::ForFields
          for_field :float_field do |name:, table:, array:, default:, comment_text:, allow_null:|
            # update the dynamic documentation
            add_documentation <<~DESCRIPTION
              Add an #{array ? "array of floats" : "float"}
              column named `#{name}` to the `#{table.schema.name}'.'#{table.name}` table.
              #{allow_null ? "This column can be null." : ""}
            DESCRIPTION

            # The data type of the column. Where n is a precision value between 1 and 24, PostgreSQL
            # accepts float(n) and assumes the data type of `real`. For greater precision, the double
            # type should be used.
            data_type = array ? :"real[]" : :real

            # add the column to the DynamicMigrations table
            table.add_column name, data_type, null: allow_null, default: default, description: comment_text
          end
        end
      end
    end
  end
end
