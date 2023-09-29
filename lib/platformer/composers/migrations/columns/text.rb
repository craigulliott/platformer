# frozen_string_literal: true

module Platformer
  module Composers
    module Migrations
      module Columns
        # Add all text columns to their respective tables within DynamicMigrations
        class Text < Parsers::FinalModels::ForFields
          for_field :text_field do |name:, table:, array:, database_default:, description:, allow_null:|
            # update the dynamic documentation
            add_documentation <<~DESCRIPTION
              Add an #{array ? "array of texts" : "text"}
              column named `#{name}` to the `#{table.schema.name}'.'#{table.name}` table.
              #{allow_null ? "This column can be null." : ""} If a validate_maximum_length validator is used,
              then this will be backed by the equivilent varchar column in postgres. If a specific length is
              expected and validated with a `validate_length_is` validator, then this will be backed by a char
              column.
            DESCRIPTION

            # The data type of the column.
            base_type = :text

            # if a maximum length is set, then use the equivilent varchar column
            for_method :validate_maximum_length do |value:|
              base_type = :"varchar(#{value})"
            end

            # if an exact length is set, then use the equivilent varchar column
            for_method :validate_length_is do |value:|
              base_type = :"char(#{value})"
            end

            data_type = array ? :"#{base_type}[]" : base_type

            # add the column to the DynamicMigrations table
            table.add_column name, data_type, null: allow_null, default: database_default, description: description
          end
        end
      end
    end
  end
end
