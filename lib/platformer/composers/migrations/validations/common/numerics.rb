# frozen_string_literal: true

module Platformer
  module Composers
    module Migrations
      module Validations
        module Common
          # Add all numeric validations to their respective columns within DynamicMigrations
          class Numerics < Parsers::Models::ForFields
            for_numeric_fields do |name:, table:, array:, description:, allow_null:|
              column = table.column name

              # if the validate_greater_than validation was used
              for_method :validate_greater_than do |value:, deferrable:, initially_deferred:, description:|
                add_documentation <<~DESCRIPTION
                  Update this models table (`#{column.table.schema.name}'.'#{column.table.name}`)
                  within DynamicMigrations and add a constraint to assert that any values provided
                  to the `#{column.name}` column must be greater than #{value}.
                DESCRIPTION

                if deferrable
                  add_documentation <<~DESCRIPTION
                    This constraint is deferrable and is #{initially_deferred ? "" : "not "}deferred by default.
                  DESCRIPTION
                end

                validation_name = :"#{column.name}_gt"

                final_description = description || Databases::Migrations::Templates::Validations::GreaterThan::DEFAULT_DESCRIPTION

                # add the validation to the table
                check_clause = <<~SQL
                  #{column.name} > #{value}
                SQL
                table.add_validation validation_name, [column.name], check_clause, template: :greater_than, deferrable: deferrable, initially_deferred: initially_deferred, description: final_description
              end

              # if the validate_greater_than_or_equal_to validation was used
              for_method :validate_greater_than_or_equal_to do |value:, deferrable:, initially_deferred:, description:|
                add_documentation <<~DESCRIPTION
                  Update this models table (`#{column.table.schema.name}'.'#{column.table.name}`)
                  within DynamicMigrations and add a constraint to assert that any values provided
                  to the `#{column.name}` column must be greater than or equal to #{value}.
                DESCRIPTION

                if deferrable
                  add_documentation <<~DESCRIPTION
                    This constraint is deferrable and is #{initially_deferred ? "" : "not "}deferred by default.
                  DESCRIPTION
                end

                validation_name = :"#{column.name}_gte"

                final_description = description || Databases::Migrations::Templates::Validations::GreaterThanOrEqualTo::DEFAULT_DESCRIPTION

                # add the validation to the table
                check_clause = <<~SQL
                  #{column.name} >= #{value}
                SQL
                table.add_validation validation_name, [column.name], check_clause, template: :greater_than_or_equal_to, deferrable: deferrable, initially_deferred: initially_deferred, description: final_description
              end

              # if the validate_less_than validation was used
              for_method :validate_less_than do |value:, deferrable:, initially_deferred:, description:|
                add_documentation <<~DESCRIPTION
                  Update this models table (`#{column.table.schema.name}'.'#{column.table.name}`)
                  within DynamicMigrations and add a constraint to assert that any values provided
                  to the `#{column.name}` column must be less than #{value}.
                DESCRIPTION

                if deferrable
                  add_documentation <<~DESCRIPTION
                    This constraint is deferrable and is #{initially_deferred ? "" : "not "}deferred by default.
                  DESCRIPTION
                end

                validation_name = :"#{column.name}_lt"

                final_description = description || Databases::Migrations::Templates::Validations::LessThan::DEFAULT_DESCRIPTION

                # add the validation to the table
                check_clause = <<~SQL
                  #{column.name} < #{value}
                SQL
                table.add_validation validation_name, [column.name], check_clause, template: :less_than, deferrable: deferrable, initially_deferred: initially_deferred, description: final_description
              end

              # if the validate_less_than_or_equal_to validation was used
              for_method :validate_less_than_or_equal_to do |value:, deferrable:, initially_deferred:, description:|
                add_documentation <<~DESCRIPTION
                  Update this models table (`#{column.table.schema.name}'.'#{column.table.name}`)
                  within DynamicMigrations and add a constraint to assert that any values provided
                  to the `#{column.name}` column must be less than or equal to #{value}.
                DESCRIPTION

                if deferrable
                  add_documentation <<~DESCRIPTION
                    This constraint is deferrable and is #{initially_deferred ? "" : "not "}deferred by default.
                  DESCRIPTION
                end

                validation_name = :"#{column.name}_lte"

                final_description = description || Databases::Migrations::Templates::Validations::LessThanOrEqualTo::DEFAULT_DESCRIPTION

                # add the validation to the table
                check_clause = <<~SQL
                  #{column.name} <= #{value}
                SQL
                table.add_validation validation_name, [column.name], check_clause, template: :less_than_or_equal_to, deferrable: deferrable, initially_deferred: initially_deferred, description: final_description
              end

              # if the validate_equal_to validation was used
              for_method :validate_equal_to do |value:, deferrable:, initially_deferred:, description:|
                add_documentation <<~DESCRIPTION
                  Update this models table (`#{column.table.schema.name}'.'#{column.table.name}`)
                  within DynamicMigrations and add a constraint to assert that any values provided
                  to the `#{column.name}` column must be equal to the number #{value}.
                DESCRIPTION

                if deferrable
                  add_documentation <<~DESCRIPTION
                    This constraint is deferrable and is #{initially_deferred ? "" : "not "}deferred by default.
                  DESCRIPTION
                end

                validation_name = :"#{column.name}_eq"

                final_description = description || Databases::Migrations::Templates::Validations::EqualTo::DEFAULT_DESCRIPTION

                # add the validation to the table
                check_clause = <<~SQL
                  #{column.name} = #{value}
                SQL
                table.add_validation validation_name, [column.name], check_clause, deferrable: deferrable, initially_deferred: initially_deferred, description: final_description
              end
            end
          end
        end
      end
    end
  end
end
