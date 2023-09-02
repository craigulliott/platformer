# frozen_string_literal: true

module Platformer
  module Composers
    module Migrations
      module Columns
        # Add all currency columns to their respective tables within DynamicMigrations
        class Currency < Parsers::FinalModels::ForFields
          # for each time the :currency_field DSL was used on this Model
          for_field :currency_field do |prefix:, database:, table:, array:, default:, comment_text:, allow_null:|
            name_prepend = prefix.nil? ? "" : "#{prefix}_"

            name = :"#{name_prepend}currency"

            enum_type_name = database.find_or_create_shared_enum Constants::ISO::CurrencyCode

            # update the dynamic documentation
            add_documentation <<~DESCRIPTION
              Update DynamicMigrations and add an #{array ? "array of currencys" : "currency"}
              column named `#{name}` to the `#{table.schema.name}'.'#{table.name}` table.
              #{allow_null ? "This column can be null." : ""}. The column type is
              `#{enum_type_name}`. #{Constants::ISO::CurrencyCode.description}
            DESCRIPTION

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
