# frozen_string_literal: true

module Platformer
  module Composers
    module Migrations
      module Columns
        # Add all char columns to their respective tables within DynamicMigrations
        class Char < Parsers::FinalModels::ForFields
          # for each time the :char_field DSL was used on this Model
          for_field :char_field do |name:, table:, array:, default:, length:, comment_text:, allow_null:|
            # update the dynamic documentation
            add_documentation <<~DESCRIPTION
              Update DynamicMigrations and add an #{array ? "array of chars" : "char"}
              column named `#{name}` to the `#{table.schema.name}'.'#{table.name}` table.
              #{allow_null ? "This column can be null." : ""}
            DESCRIPTION

            # The data type of the column.
            data_type = length.nil? ? "char" : "char(#{length})"

            if array
              data_type += "[]"
            end

            # add the column to the DynamicMigrations table
            table.add_column name, data_type.to_sym, null: allow_null, default: default, description: comment_text
          end
        end
      end
    end
  end
end
