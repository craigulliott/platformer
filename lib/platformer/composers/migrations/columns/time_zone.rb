# frozen_string_literal: true

module Platformer
  module Composers
    module Migrations
      module Columns
        # Add all time_zone columns to their respective tables within DynamicMigrations
        class TimeZone < Parsers::Models::ForFields
          # for each time the :time_zone_field DSL was used on this Model
          for_field :time_zone_field do |prefix:, database:, table:, array:, database_default:, description:, allow_null:|
            name_prepend = prefix.nil? ? "" : "#{prefix}_"

            name = :"#{name_prepend}time_zone"

            enum = database.find_or_create_shared_enum Constants::TimeZone
            enum_type_name = enum.full_name

            # update the dynamic documentation
            add_documentation <<~DESCRIPTION
              Add an #{array ? "array of time_zones" : "time_zone"}
              column named `#{name}` to the `#{table.schema.name}'.'#{table.name}` table.
              #{allow_null ? "This column can be null." : ""}. The column type is
              `#{enum_type_name}`. #{Constants::TimeZone.description}
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
