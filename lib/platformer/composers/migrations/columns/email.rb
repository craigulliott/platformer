# frozen_string_literal: true

module Platformer
  module Composers
    module Migrations
      module Columns
        # Add all email columns to their respective tables within DynamicMigrations
        class Email < Parsers::FinalModels::ForFields
          for_field :email_field do |name:, database:, table:, array:, default:, comment_text:, allow_null:|
            # update the dynamic documentation
            add_documentation <<~DESCRIPTION
              Add an #{array ? "array of emails" : "email"}
              column named `#{name}` to the `#{table.schema.name}'.'#{table.name}` table.
              #{allow_null ? "This column can be null." : ""}
            DESCRIPTION

            # The data type of the column.
            data_type = array ? :"citext[]" : :citext

            # ensuure the citext extension is installed
            database.ensure_postgres_extension :citext

            # add the column to the DynamicMigrations table
            table.add_column name, data_type, null: allow_null, default: default, description: comment_text
          end
        end
      end
    end
  end
end
