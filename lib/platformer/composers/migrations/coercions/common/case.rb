# frozen_string_literal: true

module Platformer
  module Composers
    module Migrations
      module Coercions
        module Common
          # install validations to assert that the case coercion rules were followed
          class Case < Parsers::FinalModels::ForFields
            for_string_fields except: :citext_field do |name:, table:, column:, array:, default:, comment_text:, allow_null:|
              for_method [:uppercase, :lowercase] do |method_name:, comment:|
                wanted_case = method_name
                unwanted_case = (method_name == :uppercase) ? :lowercase : :uppercase

                add_documentation <<~DESCRIPTION
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
