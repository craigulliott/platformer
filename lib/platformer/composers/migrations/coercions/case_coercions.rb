# frozen_string_literal: true

module Platformer
  module Composers
    module Migrations
      module Coercions
        # install validations to assert that the case coercion rules were followed
        class CaseCoercions < DSLCompose::Parser
          # Process the parser for every decendant of PlatformModel which does not have
          # it's own decendents. These represent Models which will have a coresponding
          # ActiveRecord class created for them, and thus a table within the database
          for_final_children_of PlatformModel do |child_class:|
            # the table structure object from DynamicMigrations, this was created and
            # the result cached within the CreateStructure parser
            table = ModelToTableStructure.get_table_structure child_class

            # for each field on this model which can have the case_coercions
            for_dsl [:char_field, :text_field] do |name:, array:|
              # Get the coresponding column object from DynamicMigrations for this field
              column = table.column name

              for_method [:uppercase, :lowercase] do |method_name:, comment:|
                wanted_case = method_name
                unwanted_case = (method_name == :uppercase) ? :lowercase : :uppercase

                description <<~DESCRIPTION
                  Update this models table (`#{column.table.schema.name}'.'#{column.table.name}`)
                  within DynamicMigrations and add a constraint to assert that any values provided
                  to the `#{column.name}` column must not contain any #{unwanted_case} letters.
                DESCRIPTION

                validation_name = :"#{column.name}_#{wanted_case}_only"

                # Add the validation to the table, assert that forcing everything to
                # the desired case did not result in any differences. Note, it is safe to
                # pass NULL to upper(). If this column is an array, then we serialize the
                # array before comparing it.
                pg_case_method_name = (wanted_case == :uppercase) ? :upper : :lower
                check_clause = if array
                  <<~SQL
                    #{column.name} IS NULL OR #{pg_case_method_name}(ARRAY_REMOVE(#{column.name}, NULL)::text) IS NOT DISTINCT FROM ARRAY_REMOVE(#{column.name}, NULL)::text
                  SQL
                else
                  <<~SQL
                    #{column.name} IS NOT DISTINCT FROM #{pg_case_method_name}(#{column.name})
                  SQL
                end
                table.add_validation validation_name, [column.name], check_clause, description: <<~COMMENT
                  #{comment}
                  This validation asserts that the #{wanted_case} coercion has been applied to this field
                COMMENT
              end
            end
          end
        end
      end
    end
  end
end
