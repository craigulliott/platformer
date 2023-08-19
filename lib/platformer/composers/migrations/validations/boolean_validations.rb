# frozen_string_literal: true

module Platformer
  module Composers
    module Migrations
      module Validations
        # install all the validations specifically designed for boolean fields
        class BooleanValidations < DSLCompose::Parser
          # Process the parser for every decendant of PlatformModel which does not have
          # it's own decendents. These represent Models which will have a coresponding
          # ActiveRecord class created for them, and thus a table within the database
          for_final_children_of PlatformModel do |child_class:|
            # the table structure object from DynamicMigrations, this was created and
            # the result cached within the CreateStructure parser
            table = ModelToTableStructure.get_table_structure child_class

            # for each boolean field on this Model or any of it's ancestors
            for_dsl [:boolean_field] do |name:|
              # Get the coresponding column object from DynamicMigrations for this field
              column = table.column name

              for_method :validate_is_true do |comment:|
                description <<~DESCRIPTION
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
                description <<~DESCRIPTION
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
