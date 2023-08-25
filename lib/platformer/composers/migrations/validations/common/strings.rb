# frozen_string_literal: true

module Platformer
  module Composers
    module Migrations
      module Validations
        module Common
          # Add all string validations to their respective columns within DynamicMigrations
          class Strings < Parsers::FinalModels::ForFields
            for_string_fields do |name:, table:, column:, array:, default:, comment_text:, allow_null:|
              # if the validate_minimum_length validation was used
              for_method [
                :validate_minimum_length,
                :validate_maximum_length,
                :validate_length_is
              ] do |method_name:, value:, deferrable:, initially_deferred:, comment:|
                # the difference between the three length validations
                case method_name
                when :validate_minimum_length
                  desc = "be at least #{value} characters long"
                  validation_name = :"#{column.name}_min_len"
                  operator = ">="

                when :validate_maximum_length
                  desc = "be no longer than #{value} characters"
                  validation_name = :"#{column.name}_max_len"
                  operator = "<="

                when :validate_length_is
                  desc = "have exactly #{value} characters"
                  validation_name = :"#{column.name}_length"
                  operator = "="
                end

                description <<~DESCRIPTION
                  Update this models table (`#{column.table.schema.name}'.'#{column.table.name}`)
                  within DynamicMigrations and add a constraint to assert that any values provided
                  to the `#{column.name}` column must #{desc}.
                DESCRIPTION

                if deferrable
                  description <<~DESCRIPTION
                    This constraint is deferrable and is #{initially_deferred ? "" : "not "}deferred by default.
                  DESCRIPTION
                end

                # add the validation to the table
                check_clause = <<~SQL
                  LENGTH(#{column.name}) #{operator} #{value}
                SQL
                table.add_validation validation_name, [column.name], check_clause, deferrable: deferrable, initially_deferred: initially_deferred, description: comment
              end

              # if the validate_format validation was used
              for_method :validate_format do |value:, deferrable:, initially_deferred:, comment:|
                description <<~DESCRIPTION
                  Update this models table (`#{column.table.schema.name}'.'#{column.table.name}`)
                  within DynamicMigrations and add a constraint to assert that any values provided
                  to the `#{column.name}` column must be of the format #{value}.
                DESCRIPTION

                if deferrable
                  description <<~DESCRIPTION
                    This constraint is deferrable and is #{initially_deferred ? "" : "not "}deferred by default.
                  DESCRIPTION
                end

                validation_name = :"#{column.name}_format"

                # add the validation to the table
                # null values are automatically permitted with the sql below
                check_clause = <<~SQL
                  #{column.name} ~ '#{value}'
                SQL
                table.add_validation validation_name, [column.name], check_clause, deferrable: deferrable, initially_deferred: initially_deferred, description: comment
              end

              # if the validate_in validation was used
              for_method [
                :validate_in,
                :validate_not_in
              ] do |method_name:, values:, deferrable:, initially_deferred:, comment:|
                # so we can easily differentiate between these two methods
                not_in = method_name == :validate_not_in

                description <<~DESCRIPTION
                  Update this models table (`#{column.table.schema.name}'.'#{column.table.name}`)
                  within DynamicMigrations and add a constraint to assert that any values provided
                  to the `#{column.name}` column must #{not_in ? "not be" : "be"} one of #{values.to_sentence}.
                DESCRIPTION

                if deferrable
                  description <<~DESCRIPTION
                    This constraint is deferrable and is #{initially_deferred ? "" : "not "}deferred by default.
                  DESCRIPTION
                end

                validation_name = :"#{column.name}_#{not_in ? "not_in" : "in"}"

                # add the validation to the table
                # null values are automatically permitted with the sql below
                quoted_values = values.map { |v| v.gsub("'", "''") }
                check_clause = <<~SQL
                  #{column.name} #{not_in ? "NOT IN" : "IN"} ('#{quoted_values.join("'::text,'")}'::text)
                SQL
                table.add_validation validation_name, [column.name], check_clause, deferrable: deferrable, initially_deferred: initially_deferred, description: comment
              end

              # if the validate_in validation was used
              for_method :validate_is_value do |value:, deferrable:, initially_deferred:, comment:|
                description <<~DESCRIPTION
                  Update this models table (`#{column.table.schema.name}'.'#{column.table.name}`)
                  within DynamicMigrations and add a constraint to assert that any values provided
                  to the `#{column.name}` column exactly equal `#{value}`.
                DESCRIPTION

                if deferrable
                  description <<~DESCRIPTION
                    This constraint is deferrable and is #{initially_deferred ? "" : "not "}deferred by default.
                  DESCRIPTION
                end

                validation_name = :"#{column.name}_is"

                # add the validation to the table
                # null values are automatically permitted with the sql below
                check_clause = <<~SQL
                  #{column.name} = '#{value}'
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
