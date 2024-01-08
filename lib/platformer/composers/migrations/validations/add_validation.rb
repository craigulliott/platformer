# frozen_string_literal: true

module Platformer
  module Composers
    module Migrations
      module Validations
        # install all the custom validations for this model
        # todo: not tested
        class AddValidation < Parsers::Models
          for_dsl :add_validation do |name:, check_clause:, table:, description:|
            add_documentation <<~DESCRIPTION
              Update this models table (`#{table.schema.name}'.'#{table.name}`)
              within DynamicMigrations and add a custom validation named `#{name}`.
              The validation's check clause is:
              #{check_clause}
            DESCRIPTION

            # add the validation to the table
            table.add_validation name, nil, check_clause, description: description
          end
        end
      end
    end
  end
end
