# frozen_string_literal: true

module Platformer
  module Composers
    module Migrations
      module Validations
        module Fields
          # install all the validations specifically designed for boolean fields
          class Boolean < Parsers::FinalModels::ForFields
            for_field :boolean_field do |name:, table:, column:, array:, default:, comment_text:, allow_null:|
              for_method :validate_is_true do |comment:|
                add_documentation <<~DESCRIPTION
                  Update this models table (`#{column.table.schema.name}'.'#{column.table.name}`)
                  within DynamicMigrations and add a constraint to assert that any values provided
                  to the `#{column.name}` column must be true (can not be false).
                DESCRIPTION

                validation_name = :"#{column.name}_is_true"

                # add the validation to the table
                check_clause = <<~SQL
                  #{column.name} IS TRUE
                SQL
                table.add_validation validation_name, [column.name], check_clause, description: comment
              end

              for_method :validate_is_false do |comment:|
                add_documentation <<~DESCRIPTION
                  Update this models table (`#{column.table.schema.name}'.'#{column.table.name}`)
                  within DynamicMigrations and add a constraint to assert that any values provided
                  to the `#{column.name}` column must be false (can not be true).
                DESCRIPTION

                validation_name = :"#{column.name}_is_false"

                # add the validation to the table
                check_clause = <<~SQL
                  #{column.name} IS FALSE
                SQL
                table.add_validation validation_name, [column.name], check_clause, description: comment
              end
            end
          end
        end
      end
    end
  end
end
