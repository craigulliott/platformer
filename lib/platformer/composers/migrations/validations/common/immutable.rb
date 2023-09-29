# frozen_string_literal: true

module Platformer
  module Composers
    module Migrations
      module Validations
        module Common
          class Immutable < Parsers::FinalModels::ForFields
            for_all_fields do |column_names:, database:, table:, description:, allow_null:|
              # Can never be changed after creation
              for_method :immutable do
                add_documentation <<~DESCRIPTION
                  Add a trigger to this table (`#{table.schema.name}'.'#{table.name}`)
                  and call a function which prevents the value of `#{column_names.to_sentence}` from
                  ever being updated.
                DESCRIPTION

                column_names.each do |column_name|
                  column = table.column column_name
                  database.make_column_immutable column
                end
              end

              # Can never be changed once set the first time (from NULL)
              for_method :immutable_once_set do
                unless allow_null
                  raise UnsupportedAllowNullError, "You can not use `immutable_once_set` on columns which do not allow null. Use `immutable` instead."
                end

                add_documentation <<~DESCRIPTION
                  Add a trigger to this table (`#{table.schema.name}'.'#{table.name}`)
                  and call a function which prevents the value of `#{column_names.to_sentence}` from
                  being updated after it has been first set to a value (meaning,
                  if it was created with the value of null, then it can be updated in the future
                  to a non value, but at that point the value can never be updated again).
                DESCRIPTION

                column_names.each do |column_name|
                  column = table.column column_name
                  database.make_column_immutable_once_set column
                end
              end
            end
          end
        end
      end
    end
  end
end
