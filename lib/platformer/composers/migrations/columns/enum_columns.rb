# frozen_string_literal: true

module Platformer
  module Composers
    module Migrations
      module Columns
        # Add all enum columns to their respective tables within DynamicMigrations
        class EnumColumns < Parsers::FinalModels::ForFields
          # for each time the :enum_field DSL was used on this Model
          for_field :enum_field do |name:, values:, schema:, table:, array:, default:, comment_text:, allow_null:|
            enum_type_name = :"#{table.name}__#{name}_values"

            # update the dynamic documentation
            description <<~DESCRIPTION
              Update DynamicMigrations and add an #{array ? "array of enums" : "enum"}
              column named `#{name}` to the `#{table.schema.name}'.'#{table.name}` table.
              #{allow_null ? "This column can be null." : ""}. The enum type is called
              `#{enum_type_name}` and it has the values '#{values.join("', '")}'.
            DESCRIPTION

            schema.add_enum enum_type_name, values, description: <<~COMMENT
              This type is for the enum column `#{name}` on the `#{table.schema.name}'.'#{table.name}` table.
            COMMENT

            # The data type of the column.
            data_type = array ? :"#{enum_type_name}[]" : enum_type_name

            # add the column to the DynamicMigrations table
            table.add_column name, data_type.to_sym, null: allow_null, default: default, description: comment_text
          end
        end
      end
    end
  end
end
