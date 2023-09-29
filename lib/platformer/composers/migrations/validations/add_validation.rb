# frozen_string_literal: true

module Platformer
  module Composers
    module Migrations
      module Validations
        # install all the custom validations for this model
        warn "not tested"
        class AddValidation < Parsers::FinalModels
          for_dsl :add_validation do |name:, check_clause:, table:, description:|
            add_documentation <<~DESCRIPTION
              Update this models table (`#{column.table.schema.name}'.'#{column.table.name}`)
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
