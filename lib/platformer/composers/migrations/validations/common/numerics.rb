# frozen_string_literal: true

module Platformer
  module Composers
    module Migrations
      module Validations
        module Common
          # Add all numeric validations to their respective columns within DynamicMigrations
          class Numerics < Parsers::FinalModels::ForFields
            for_numeric_fields do |name:, table:, column:, array:, default:, comment_text:, allow_null:|
              # if the validate_greater_than validation was used
              for_method :validate_greater_than do |value:, deferrable:, initially_deferred:, comment:|
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

                # add the validation to the table
                check_clause = <<~SQL
                  #{column.name} > #{value}
                SQL
                table.add_validation validation_name, [column.name], check_clause, deferrable: deferrable, initially_deferred: initially_deferred, description: comment
              end

              # if the validate_greater_than_or_equal_to validation was used
              for_method :validate_greater_than_or_equal_to do |value:, deferrable:, initially_deferred:, comment:|
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

                # add the validation to the table
                check_clause = <<~SQL
                  #{column.name} >= #{value}
                SQL
                table.add_validation validation_name, [column.name], check_clause, deferrable: deferrable, initially_deferred: initially_deferred, description: comment
              end

              # if the validate_less_than validation was used
              for_method :validate_less_than do |value:, deferrable:, initially_deferred:, comment:|
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

                # add the validation to the table
                check_clause = <<~SQL
                  #{column.name} < #{value}
                SQL
                table.add_validation validation_name, [column.name], check_clause, deferrable: deferrable, initially_deferred: initially_deferred, description: comment
              end

              # if the validate_less_than_or_equal_to validation was used
              for_method :validate_less_than_or_equal_to do |value:, deferrable:, initially_deferred:, comment:|
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

                # add the validation to the table
                check_clause = <<~SQL
                  #{column.name} <= #{value}
                SQL
                table.add_validation validation_name, [column.name], check_clause, deferrable: deferrable, initially_deferred: initially_deferred, description: comment
              end

              # if the validate_equal_to validation was used
              for_method :validate_equal_to do |value:, deferrable:, initially_deferred:, comment:|
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

                # add the validation to the table
                check_clause = <<~SQL
                  #{column.name} = #{value}
                SQL
                table.add_validation validation_name, [column.name], check_clause, deferrable: deferrable, initially_deferred: initially_deferred, description: comment
              end
            end
          end
        end
      end
    end
  end
end
