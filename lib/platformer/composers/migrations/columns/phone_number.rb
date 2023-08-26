# frozen_string_literal: true

module Platformer
  module Composers
    module Migrations
      module Columns
        # Add all phone_number columns to their respective tables within DynamicMigrations
        class PhoneNumber < Parsers::FinalModels::ForFields
          for_field :phone_number_field do |name:, database:, table:, reader:, comment_text:, allow_null:|
            # update the dynamic documentation
            description <<~DESCRIPTION
              Update DynamicMigrations and add columns named `#{name}_dialing_code`
              and `#{name}_phone_number` to the `#{table.schema.name}'.'#{table.name}`
              table. #{allow_null ? "This column can be null." : ""}
            DESCRIPTION

            # the default value for this column, or null if one was not provided
            default_dialing_code = reader.default&.dialing_code
            default_phone_number = reader.default&.phone_number

            enum_type_name = database.find_or_create_shared_enum Constants::ISO::DialingCode

            # add the dialing_code column to the DynamicMigrations table
            table.add_column :"#{name}_dialing_code", enum_type_name, null: allow_null, default: default_dialing_code, description: <<~DESCRIPTION
              #{comment_text}
              This is the international dialing code, which is a + followed by a
              number (e.g. "+1" for the USA and "+44" for the UK).
            DESCRIPTION

            # add the phone_number column to the DynamicMigrations table
            table.add_column :"#{name}_phone_number", :"varchar(15)", null: allow_null, default: default_phone_number, description: <<~DESCRIPTION
              #{comment_text}
              This is the unformatted phone number without the international dialing
              code. For example, in the US this is a 10 digit number.
            DESCRIPTION
          end
        end
      end
    end
  end
end
