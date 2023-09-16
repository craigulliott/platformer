# frozen_string_literal: true

module Platformer
  module Composers
    module Migrations
      module Columns
        # Add all language columns to their respective tables within DynamicMigrations
        class Language < Parsers::FinalModels::ForFields
          # for each time the :language_field DSL was used on this Model
          for_field :language_field do |prefix:, database:, table:, array:, default:, comment_text:, allow_null:|
            name_prepend = prefix.nil? ? "" : "#{prefix}_"

            name = :"#{name_prepend}language"

            enum = database.find_or_create_shared_enum Constants::ISO::LanguageCode
            enum_type_name = enum.full_name

            # update the dynamic documentation
            add_documentation <<~DESCRIPTION
              Add an #{array ? "array of languages" : "language"}
              column named `#{name}` to the `#{table.schema.name}'.'#{table.name}` table.
              #{allow_null ? "This column can be null." : ""}. The column type is
              `#{enum_type_name}`. #{Constants::ISO::LanguageCode.description}
            DESCRIPTION

            # The data type of the column.
            data_type = array ? :"#{enum.full_name}[]" : enum.full_name

            # add the column to the DynamicMigrations table
            table.add_column name, data_type.to_sym, enum: enum, null: allow_null, default: default, description: comment_text
          end
        end
      end
    end
  end
end
