module Platformer
  module Databases
    class Migrations
      module Helpers
        module Validations
          module StringLength
            # these functions are called from our custom DynamicMigrations template, it exists just to make the
            # generated migrations cleaner and easier to read
            def validate_minimum_length table_name, column_name, value, name: nil, comment: nil
              final_name = name || :"#{column_name}_min_len"
              final_comment = comment || Templates::Validations::MinimumLength::DEFAULT_COMMENT
              add_validation table_name, name: final_name, initially_deferred: false, deferrable: false, comment: final_comment do
                "LENGTH(#{column_name}) >= #{value}"
              end
            end

            def validate_maximum_length table_name, column_name, value, name: nil, comment: nil
              final_name = name || :"#{column_name}_max_len"
              final_comment = comment || Templates::Validations::MaximumLength::DEFAULT_COMMENT
              add_validation table_name, name: final_name, initially_deferred: false, deferrable: false, comment: final_comment do
                "LENGTH(#{column_name}) <= #{value}"
              end
            end

            def validate_length_is table_name, column_name, value, name: nil, comment: nil
              final_name = name || :"#{column_name}_length"
              final_comment = comment || Templates::Validations::LengthIs::DEFAULT_COMMENT
              add_validation table_name, name: final_name, initially_deferred: false, deferrable: false, comment: final_comment do
                "LENGTH(#{column_name}) = #{value}"
              end
            end
          end
        end
      end
    end
  end
end
