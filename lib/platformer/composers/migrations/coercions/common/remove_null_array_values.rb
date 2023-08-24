# frozen_string_literal: true

module Platformer
  module Composers
    module Migrations
      module Coercions
        module Common
          # install validations to assert that the remove_null_array_values coercion rules were followed
          class RemoveNullArrayValues < FieldParser
            for_all_fields except: [:json_field, :phone_number] do |name:, table:, column:, array:, default:, comment_text:, allow_null:|
              for_method :remove_null_array_values do |comment:|
                unless array
                  raise UnsupportedRemoveNullArrayValuesError, "`remove_null_array_values` can only be used on array fields"
                end

                description <<~DESCRIPTION
                  Update this models table (`#{column.table.schema.name}'.'#{column.table.name}`)
                  within DynamicMigrations and add a constraint to assert that the `#{column.name}`
                  array column does not contain any null values.
                DESCRIPTION

                # Enforce that the array should never contain null values.
                check_clause = <<~SQL
                  #{name} IS NULL OR ARRAY_POSITION(#{name}, NULL) IS NULL
                SQL
                table.add_validation :"#{name}_no_null_values", [name], check_clause, description: <<~COMMENT
                  This validation asserts that the array does not contain any NULL values. It will also
                  prevent adding any multidimensional arrays because trying to do so will cause postgres
                  to raise the error "searching for elements in multidimensional arrays is not supported"
                COMMENT
              end
            end
          end
        end
      end
    end
  end
end
