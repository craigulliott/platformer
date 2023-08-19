# frozen_string_literal: true

module Platformer
  module Composers
    module Migrations
      module Coercions
        # install validations to assert that the remove_null_array_values coercion rules were followed
        class RemoveNullArrayValuesCoercions < DSLCompose::Parser
          # Process the parser for every decendant of PlatformModel which does not have
          # it's own decendents. These represent Models which will have a coresponding
          # ActiveRecord class created for them, and thus a table within the database
          for_final_children_of PlatformModel do |child_class:|
            # the table structure object from DynamicMigrations, this was created and
            # the result cached within the CreateStructure parser
            table = ModelToTableStructure.get_table_structure child_class

            # for each field on this model which can have the zero_to_null_coercions
            for_dsl [
              :boolean_field,
              :char_field,
              :citext_field,
              :date_field,
              :date_time_field,
              :double_field,
              :email_field,
              :enum_field,
              :float_field,
              :integer_field,
              :numeric_field,
              :phone_number_field,
              :text_field
            ] do |name:, array:|
              # Get the coresponding column object from DynamicMigrations for this field
              column = table.column name

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
