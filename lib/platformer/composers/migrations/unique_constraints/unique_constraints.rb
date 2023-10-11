# frozen_string_literal: true

module Platformer
  module Composers
    module Migrations
      # Add all unique constraints to their respective columns within DynamicMigrations
      class UniqueConstraints < Parsers::Models::ForFields
        class WhereCanNotBeUsedWithDeferrableError < StandardError
        end

        for_all_fields do |column_names:, table:, database:, description:, allow_null:|
          # if the unique method was used within our field DSL
          for_method :unique do |scope:, description:, where:, deferrable:, initially_deferred:|
            all_column_names = column_names + scope

            if where
              add_documentation <<~DESCRIPTION
                Add a unique index to this table (`#{table.schema.name}'.'#{table.name}`)
                which covers the column#{(all_column_names.count > 1) ? "s" : ""} #{all_column_names.to_sentence}
                and applies to rows where `#{where}` is true.
              DESCRIPTION
            else
              add_documentation <<~DESCRIPTION
                Add a unique constraint to this table (`#{table.schema.name}'.'#{table.name}`)
                which covers the columns #{all_column_names.to_sentence}.
              DESCRIPTION
              if deferrable
                add_documentation <<~DESCRIPTION
                  This constraint is deferrable and is #{initially_deferred ? "" : "not "}deferred by default.
                DESCRIPTION
              else
                add_documentation <<~DESCRIPTION
                  This constraint is not deferrable.
                DESCRIPTION
              end
            end

            column_names = all_column_names.join("_")

            unique_constraint_name = :"#{table.name}_#{column_names}_uq"
            # if the name is too long, then shorten the column names
            if unique_constraint_name.length > 63
              column_names_shortened = all_column_names.map { |c| Databases.abbreviate_table_name c }.join("_")
              unique_constraint_name = :"#{table.name}_#{column_names_shortened}_uq"

              # if it is still too long, then shorten the table  name too
              if unique_constraint_name.length > 63
                short_name = Databases.abbreviate_table_name table.name
                unique_constraint_name = :"#{short_name}_#{column_names_shortened}_uq"
              end
            end

            database.add_unique_constraint unique_constraint_name, table, all_column_names, where: where, deferrable: deferrable, initially_deferred: initially_deferred, description: description
          end
        end
      end
    end
  end
end
