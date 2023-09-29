# frozen_string_literal: true

module Platformer
  module Composers
    module Migrations
      module Coercions
        module Common
          # install validations to assert that the remove_null_array_values coercion rules were followed
          class RemoveNullArrayValues < Parsers::FinalModels::ForFields
            for_all_single_column_fields except: :json_field do |column_name:, table:, array:, description:, allow_null:|
              for_method :remove_null_array_values do |description:|
                unless array
                  raise UnsupportedRemoveNullArrayValuesError, "`remove_null_array_values` can only be used on array fields"
                end

                column = table.column column_name

                add_documentation <<~DESCRIPTION
                  Update this models table (`#{column.table.schema.name}'.'#{column.table.name}`)
                  within DynamicMigrations and add a constraint to assert that the `#{column.name}`
                  array column does not contain any null values.
                DESCRIPTION

                # Enforce that the array should never contain null values.
                check_clause = <<~SQL
                  #{column_name} IS NULL OR ARRAY_POSITION(#{column_name}, NULL) IS NULL
                SQL
                table.add_validation :"#{column_name}_no_null_values", [column_name], check_clause, description: <<~DESCRIPTION
                  This validation asserts that the array does not contain any NULL values. It will also
                  prevent adding any multidimensional arrays because trying to do so will cause postgres
                  to raise the error "searching for elements in multidimensional arrays is not supported"
                DESCRIPTION
              end
            end
          end
        end
      end
    end
  end
end
