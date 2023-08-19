# frozen_string_literal: true

module Platformer
  module Composers
    module Migrations
      module Coercions
        # install validations to assert that the empty_array_to_null coercion rules were followed
        class EmptyArrayToNullCoercions < DSLCompose::Parser
          class UnsupportedEmptyArrayToNullError < StandardError
          end

          # Process the parser for every decendant of PlatformModel which does not have
          # it's own decendents. These represent Models which will have a coresponding
          # ActiveRecord class created for them, and thus a table within the database
          for_final_children_of PlatformModel do |child_class:|
            # the table structure object from DynamicMigrations, this was created and
            # the result cached within the CreateStructure parser
            table = ModelToTableStructure.get_table_structure child_class

            # for each field on this model which can have the empty_array_to_null coercions
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

              for_method :empty_array_to_null do |method_name:, comment:|
                unless array
                  raise UnsupportedEmptyArrayToNullError, "`empty_array_to_null` can only be used on array fields"
                end

                description <<~DESCRIPTION
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
