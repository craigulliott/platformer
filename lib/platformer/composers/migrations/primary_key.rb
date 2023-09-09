# frozen_string_literal: true

module Platformer
  module Composers
    module Migrations
      class PrimaryKey < Parsers::FinalModels
        for_dsl :primary_key do |column_names:, table:, database:, comment:|
          # if no column names were provided, then create a new one called `id`
          if column_names.empty?
            default_column_name = :id

            # update the dynamic documentation
            add_documentation <<~DESCRIPTION
              And add a column called `#{default_column_name}` with type `uuid` to
              the `#{table.schema.name}'.'#{table.name}` table. This column can not
              be null, and defaults to uuid_generate_v4().
            DESCRIPTION

            # add the column to the DynamicMigrations table
            column = table.add_column default_column_name, :uuid, null: false, default: "uuid_generate_v4()", description: comment

            # make the ID immutable
            database.make_column_immutable column

            # add id to the column names, as this will be used to create
            # the primary key below
            column_names << default_column_name
          end

          # update the dynamic documentation
          add_documentation <<~DESCRIPTION
            And add a primary key to the `#{table.schema.name}'.'#{table.name}`
            table which covers the columns '#{column_names.join("', '")}'.
          DESCRIPTION

          # add the column to the DynamicMigrations table
          primary_key_name = :"#{table.name}_pk"
          table.add_primary_key primary_key_name, column_names, description: comment
        end
      end
    end
  end
end
