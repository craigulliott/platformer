module Platformer
  module Databases
    class Migrations
      module Helpers
        module Validations
          module Numeric
            # these functions are called from our custom DynamicMigrations template, it exists just to make the
            # generated migrations cleaner and easier to read
            def validate_greater_than_or_equal_to table_name, column_name, value, name: nil, comment: nil
              final_name = name || :"#{column_name}_gte"
              final_comment = comment || Templates::Validations::GreaterThanOrEqualTo::DEFAULT_COMMENT
              add_validation table_name, name: final_name, initially_deferred: false, deferrable: false, comment: final_comment do
                "#{column_name} >= #{value}"
              end
            end

            def validate_greater_than table_name, column_name, value, name: nil, comment: nil
              final_name = name || :"#{column_name}_gt"
              final_comment = comment || Templates::Validations::GreaterThan::DEFAULT_COMMENT
              add_validation table_name, name: final_name, initially_deferred: false, deferrable: false, comment: final_comment do
                "#{column_name} > #{value}"
              end
            end

            def validate_less_than_or_equal_to table_name, column_name, value, name: nil, comment: nil
              final_name = name || :"#{column_name}_lte"
              final_comment = comment || Templates::Validations::LessThanOrEqualTo::DEFAULT_COMMENT
              add_validation table_name, name: final_name, initially_deferred: false, deferrable: false, comment: final_comment do
                "#{column_name} <= #{value}"
              end
            end

            def validate_less_than table_name, column_name, value, name: nil, comment: nil
              final_name = name || :"#{column_name}_lt"
              final_comment = comment || Templates::Validations::LessThan::DEFAULT_COMMENT
              add_validation table_name, name: final_name, initially_deferred: false, deferrable: false, comment: final_comment do
                "#{column_name} < #{value}"
              end
            end

            def validate_equal_to table_name, column_name, value, name: nil, comment: nil
              final_name = name || :"#{column_name}_eq"
              final_comment = comment || Templates::Validations::EqualTo::DEFAULT_COMMENT
              add_validation table_name, name: final_name, initially_deferred: false, deferrable: false, comment: final_comment do
                "#{column_name} = #{value}"
              end
            end
          end
        end
      end
    end
  end
end
