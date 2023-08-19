# frozen_string_literal: true

module Platformer
  module Composers
    module Migrations
      module Columns
        # Add all phone_number columns to their respective tables within DynamicMigrations
        class PhoneNumberColumns < DSLCompose::Parser
          # Process the parser for every decendant of PlatformModel which does not have
          # it's own decendents. These represent Models which will have a coresponding
          # ActiveRecord class created for them, and thus a table within the database
          for_final_children_of PlatformModel do |child_class:|
            # the table structure object from DynamicMigrations, this was created and
            # the result cached within the CreateStructure parser
            table = ModelToTableStructure.get_table_structure child_class

            # for each time the :phone_number_field DSL was used on this Model
            for_dsl_or_inherited_dsl :phone_number_field do |name:, reader:|
              # update the dynamic documentation
              description <<~DESCRIPTION
                Update DynamicMigrations and add columns named `#{name}_dialing_code`
                and `#{name}_phone_number` to the `#{table.schema.name}'.'#{table.name}`
                table.
              DESCRIPTION

              # is the column allowed to be null
              allow_null = method_called? :allow_null
              if allow_null
                description "These columns can be null."
              end

              # get the comment for this column, or null if one was not provided
              comment_text = reader.comment&.comment

              # the default value for this column, or null if one was not provided
              default_dialing_code = reader.default&.dialing_code
              default_phone_number = reader.default&.phone_number

              # add the dialing_code column to the DynamicMigrations table
              table.add_column :"#{name}_dialing_code", :"constants.dialing_codes", null: allow_null, default: default_dialing_code, description: <<~DESCRIPTION
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
end
