# frozen_string_literal: true

module Platformer
  module Composers
    module Migrations
      # Add all unique constraints to their respective columns within DynamicMigrations
      class UniqueConstraints < FieldParser
        class WhereCanNotBeUsedWithDeferrableError < StandardError
        end

        for_all_fields do |name:, table:, column:, array:, default:, comment_text:, allow_null:|
          # if the unique method was used within our field DSL
          for_method :unique do |scope:, comment:, where:, deferrable:, initially_deferred:|
            # If you provide a value for where, then it is not possible to
            # set 'deferrable: true', this is because the underlying constraint
            # will be enforced by a unique index rather than a contraint, and
            # indexes can not be deferred in postgres.
            if where && deferrable
              raise WhereCanNotBeUsedWithDeferrableError, "If you provide a where clause to a unique constraint, then deferrable must be set to false"
            end

            column_names = [name] + scope

            if where
              description <<~DESCRIPTION
                Add a unique index to this table (`#{column.table.schema.name}'.'#{column.table.name}`)
                which covers the column#{(column_names.count > 1) ? "s" : ""} #{column_names.to_sentence}
                and applies to rows where `#{where}` is true.
              DESCRIPTION
            else
              description <<~DESCRIPTION
                Add a unique constraint to this table (`#{column.table.schema.name}'.'#{column.table.name}`)
                which covers the columns #{column_names.to_sentence}.
              DESCRIPTION
              if deferrable
                description <<~DESCRIPTION
                  This constraint is deferrable and is #{initially_deferred ? "" : "not "}deferred by default.
                DESCRIPTION
              else
                description <<~DESCRIPTION
                  This constraint is not deferrable.
                DESCRIPTION
              end
            end

            # if a where was provided, then we must use a unique index rather than a unique constraint
            if where
              # add the unique index to the table
              unique_index_name = "#{column.table.schema.name}_#{column.table.name}_#{column_names.join("_")}_uniq".to_sym
              table.add_index unique_index_name, column_names, unique: true, where: where, description: comment
            else
              # add the unique constraint to the table
              unique_constraint_name = "#{column.table.schema.name}_#{column.table.name}_#{column_names.join("_")}_uniq".to_sym
              table.add_unique_constraint unique_constraint_name, column_names, deferrable: deferrable, initially_deferred: initially_deferred, description: comment
            end
          end
        end
      end
    end
  end
end
