# frozen_string_literal: true

module Platformer
  module Composers
    module Migrations
      module Columns
        # Add all phone_number columns to their respective tables within DynamicMigrations
        class PhoneNumber < Parsers::Models::ForFields
          for_field :phone_number_field do |prefix:, database:, table:, reader:, description:, allow_null:|
            name_prepend = prefix.nil? ? "" : "#{prefix}_"

            # update the dynamic documentation
            add_documentation <<~DESCRIPTION
              Add columns named `#{name_prepend}dialing_code`
              and `#{name_prepend}phone_number` to the `#{table.schema.name}'.'#{table.name}`
              table. #{allow_null ? "This column can be null." : ""}
            DESCRIPTION

            # the default value for this column, or null if one was not provided
            default_dialing_code = reader.database_default&.dialing_code
            default_phone_number = reader.database_default&.phone_number

            enum = database.find_or_create_shared_enum Constants::ISO::DialingCode

            # add the dialing_code column to the DynamicMigrations table
            table.add_column :"#{name_prepend}dialing_code", enum.full_name, enum: enum, null: allow_null, default: default_dialing_code, description: <<~DESCRIPTION
              #{description}
              This is the international dialing code (without the + symbol)
              e.g. "1" for the USA and "44" for the UK.
            DESCRIPTION

            # add the phone_number column to the DynamicMigrations table
            table.add_column :"#{name_prepend}phone_number", :"character varying(15)", null: allow_null, default: default_phone_number, description: <<~DESCRIPTION
              #{description}
              This is the unformatted phone number without the international dialing
              code. For example, in the US this is a 10 digit number.
            DESCRIPTION
          end
        end
      end
    end
  end
end
