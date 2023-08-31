# frozen_string_literal: true

module Platformer
  module Composers
    module Migrations
      module Coercions
        module Common
          # install validations to assert that the empty_array_to_null coercion rules were followed
          class EmptyArrayToNull < Parsers::FinalModels::ForFields
            class UnsupportedEmptyArrayToNullError < StandardError
            end

            for_all_fields except: [:json_field, :phone_number_field] do |name:, table:, column:, array:, default:, comment_text:, allow_null:|
              for_method :empty_array_to_null do |method_name:, comment:|
                unless array
                  raise UnsupportedEmptyArrayToNullError, "`empty_array_to_null` can only be used on array fields"
                end

                add_documentation <<~DESCRIPTION
                  Update this models table (`#{column.table.schema.name}'.'#{column.table.name}`)
                  within DynamicMigrations and add a constraint to assert that the `#{column.name}`
                  column does not equal an empty array. This is because this field has an
                  empty_array_to_null coercion on it, so empty arrays should have been converted to
                  null before saving.
                DESCRIPTION

                validation_name = :"#{column.name}_empty_array_nulled"

                # Add the validation to the table, assert that the value is not an
                # empty array, (which asserts that the empty_array_to_null coercion was
                # properly applied before it was saved).
                # note, postgres' `array_length` function returns null if the array is empty
                check_clause = <<~SQL
                  #{column.name} IS NULL OR array_length(#{column.name}, 1) IS NOT NULL
                SQL
                table.add_validation validation_name, [column.name], check_clause, description: <<~COMMENT
                  #{comment}
                  This validation asserts that the empty_array_to_null coercion has been applied to this field
                COMMENT
              end
            end
          end
        end
      end
    end
  end
end
