module Platformer
  module Databases
    class Migrations
      module Helpers
        module Validations
          module Numeric
            # these functions are called from our custom DynamicMigrations template, it exists just to make the
            # generated migrations cleaner and easier to read
            def validate_greater_than_or_equal_to table_name, column_name, value, name: nil, description: nil
              final_name = name || :"#{column_name}_gte"
              final_description = description || Templates::Validations::GreaterThanOrEqualTo::DEFAULT_DESCRIPTION
              add_validation table_name, name: final_name, initially_deferred: false, deferrable: false, comment: final_description do
                "#{column_name} >= #{value}"
              end
            end

            def validate_greater_than table_name, column_name, value, name: nil, description: nil
              final_name = name || :"#{column_name}_gt"
              final_description = description || Templates::Validations::GreaterThan::DEFAULT_DESCRIPTION
              add_validation table_name, name: final_name, initially_deferred: false, deferrable: false, comment: final_description do
                "#{column_name} > #{value}"
              end
            end

            def validate_less_than_or_equal_to table_name, column_name, value, name: nil, description: nil
              final_name = name || :"#{column_name}_lte"
              final_description = description || Templates::Validations::LessThanOrEqualTo::DEFAULT_DESCRIPTION
              add_validation table_name, name: final_name, initially_deferred: false, deferrable: false, comment: final_description do
                "#{column_name} <= #{value}"
              end
            end

            def validate_less_than table_name, column_name, value, name: nil, description: nil
              final_name = name || :"#{column_name}_lt"
              final_description = description || Templates::Validations::LessThan::DEFAULT_DESCRIPTION
              add_validation table_name, name: final_name, initially_deferred: false, deferrable: false, comment: final_description do
                "#{column_name} < #{value}"
              end
            end

            def validate_equal_to table_name, column_name, value, name: nil, description: nil
              final_name = name || :"#{column_name}_eq"
              final_description = description || Templates::Validations::EqualTo::DEFAULT_DESCRIPTION
              add_validation table_name, name: final_name, initially_deferred: false, deferrable: false, comment: final_description do
                "#{column_name} = #{value}"
              end
            end
          end
        end
      end
    end
  end
end
