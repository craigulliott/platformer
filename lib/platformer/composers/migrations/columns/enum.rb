# frozen_string_literal: true

module Platformer
  module Composers
    module Migrations
      module Columns
        # Add all enum columns to their respective tables within DynamicMigrations
        class Enum < Parsers::Models::ForFields
          # for each time the :enum_field DSL was used on this Model
          for_field :enum_field do |name:, values:, schema:, table:, array:, database_default:, description:, allow_null:|
            enum_type_name = :"#{table.name}__#{name}_values"

            # update the dynamic documentation
            add_documentation <<~DESCRIPTION
              Add an #{array ? "array of enums" : "enum"}
              column named `#{name}` to the `#{table.schema.name}'.'#{table.name}` table.
              #{allow_null ? "This column can be null." : ""}. The enum type is called
              `#{enum_type_name}` and it has the values '#{values.join("', '")}'.
            DESCRIPTION

            enum = schema.add_enum enum_type_name, values, description: <<~DESCRIPTION
              This type is for the enum column `#{name}` on the `#{table.schema.name}'.'#{table.name}` table.
            DESCRIPTION

            # The data type of the column.
            data_type = array ? :"#{enum.full_name}[]" : enum.full_name

            # add the column to the DynamicMigrations table
            table.add_column name, data_type.to_sym, enum: enum, null: allow_null, default: database_default, description: description
          end
        end
      end
    end
  end
end
