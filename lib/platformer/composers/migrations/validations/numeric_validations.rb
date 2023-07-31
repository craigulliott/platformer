# frozen_string_literal: true

module Platformer
  module Composers
    module Migrations
      module Validations
        # Add all numeric validations to their respective columns within DynamicMigrations
        class NumericValidations < DSLCompose::Parser
          # Process the parser for every decendant of PlatformModel which does not have
          # it's own decendents. These represent Models which will have a coresponding
          # ActiveRecord class created for them, and thus a table within the database
          for_final_children_of PlatformModel do |child_class:|
            # the table structure object from DynamicMigrations, this was created and
            # the result cached within the CreateStructure parser
            table = ModelToTableStructure.get_table_structure child_class

            # for each integer or float that was defined on this Model or any of it's ancestors
            for_dsl_or_inherited_dsl [:integer_field, :float_field] do |name:|
              # Get the coresponding column object from DynamicMigrations for this field
              column = table.column name

              # if the validate_greater_than validation was used
              for_method :validate_greater_than do |value:|
                description <<-DESCRIPTION
                  Update this models table (`#{column.table.schema.name}'.'#{column.table.name}`)
                  within DynamicMigrations and add a constraint to assert that any values provided
                  to the `#{column.name}` column must be greater than #{value}.
                DESCRIPTION

                validation_name = "#{column.table.schema.name}_#{column.table.name}_#{column.name}_gt".to_sym

                # add the validation to the table
                table.add_validation validation_name, [column.name], <<-SQL
                  "#{column.name}" > #{value}
                SQL
              end

              # if the validate_greater_than_or_equal_to validation was used
              for_method :validate_greater_than_or_equal_to do |value:|
                description <<-DESCRIPTION
                  Update this models table (`#{column.table.schema.name}'.'#{column.table.name}`)
                  within DynamicMigrations and add a constraint to assert that any values provided
                  to the `#{column.name}` column must be greater than or equal to #{value}.
                DESCRIPTION

                validation_name = "#{column.table.schema.name}_#{column.table.name}_#{column.name}_gte".to_sym

                # add the validation to the table
                table.add_validation validation_name, [column.name], <<-SQL
                  "#{column.name}" >= #{value}
                SQL
              end

              # if the validate_less_than validation was used
              for_method :validate_less_than do |value:|
                description <<-DESCRIPTION
                  Update this models table (`#{column.table.schema.name}'.'#{column.table.name}`)
                  within DynamicMigrations and add a constraint to assert that any values provided
                  to the `#{column.name}` column must be less than #{value}.
                DESCRIPTION

                validation_name = "#{column.table.schema.name}_#{column.table.name}_#{column.name}_gt".to_sym

                # add the validation to the table
                table.add_validation validation_name, [column.name], <<-SQL
                  "#{column.name}" < #{value}
                SQL
              end

              # if the validate_less_than_or_equal_to validation was used
              for_method :validate_less_than_or_equal_to do |value:|
                description <<-DESCRIPTION
                  Update this models table (`#{column.table.schema.name}'.'#{column.table.name}`)
                  within DynamicMigrations and add a constraint to assert that any values provided
                  to the `#{column.name}` column must be less than or equal to #{value}.
                DESCRIPTION

                validation_name = "#{column.table.schema.name}_#{column.table.name}_#{column.name}_gte".to_sym

                # add the validation to the table
                table.add_validation validation_name, [column.name], <<-SQL
                  "#{column.name}" <= #{value}
                SQL
              end

              # if the validate_equal_to validation was used
              for_method :validate_equal_to do |value:|
                description <<-DESCRIPTION
                  Update this models table (`#{column.table.schema.name}'.'#{column.table.name}`)
                  within DynamicMigrations and add a constraint to assert that any values provided
                  to the `#{column.name}` column must be equal to the number #{value}.
                DESCRIPTION

                validation_name = "#{column.table.schema.name}_#{column.table.name}_#{column.name}_eq".to_sym

                # add the validation to the table
                table.add_validation validation_name, [column.name], <<-SQL
                  "#{column.name}" = #{value}
                SQL
              end
            end
          end
        end
      end
    end
  end
end
