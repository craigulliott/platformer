# frozen_string_literal: true

module Platformer
  module Composers
    module Migrations
      module Coercions
        # install validations to assert that the zero_to_null coercion rules were followed
        class ZeroToNullCoercions < DSLCompose::Parser
          # Process the parser for every decendant of PlatformModel which does not have
          # it's own decendents. These represent Models which will have a coresponding
          # ActiveRecord class created for them, and thus a table within the database
          for_final_children_of PlatformModel do |child_class:|
            # the table structure object from DynamicMigrations, this was created and
            # the result cached within the CreateStructure parser
            table = ModelToTableStructure.get_table_structure child_class

            # for each field on this model which can have the zero_to_null_coercions
            for_dsl [
              :double_field,
              :float_field,
              :integer_field,
              :numeric_field
            ] do |name:, array:|
              # Get the coresponding column object from DynamicMigrations for this field
              column = table.column name

              for_method :zero_to_null do |method_name:, comment:|
                description <<~DESCRIPTION
                  Update this models table (`#{column.table.schema.name}'.'#{column.table.name}`)
                  within DynamicMigrations and add a constraint to assert that the `#{column.name}`
                  column does not #{array ? "contain any values of 0" : "equal 0"}. This is
                  because this field has a zero_to_null coercion on it, so any 0's should have
                  been converted to null before saving.
                DESCRIPTION

                validation_name = :"#{column.name}_zero_nulled"

                # Add the validation to the table, assert that the value is not the
                # number 0, (which asserts that the zero_to_null coercion was properly
                # applied before it was saved).
                check_clause = array ? "0 = ANY(#{column.name})" : "#{column.name} IS DISTINCT FROM 0"
                table.add_validation validation_name, [column.name], check_clause, description: <<~COMMENT
                  #{comment}
                  This validation asserts that the zero_to_null coercion has been applied to this field
                COMMENT
              end
            end
          end
        end
      end
    end
  end
end
