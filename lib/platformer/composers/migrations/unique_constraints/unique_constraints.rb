# frozen_string_literal: true

module Platformer
  module Composers
    module Migrations
      # Add all unique constraints to their respective columns within DynamicMigrations
      class UniqueConstraints < Parsers::FinalModels::ForFields
        class WhereCanNotBeUsedWithDeferrableError < StandardError
        end

        for_all_fields do |column_names:, table:, database:, comment_text:, allow_null:|
          # if the unique method was used within our field DSL
          for_method :unique do |scope:, comment:, where:, deferrable:, initially_deferred:|
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

            name = "#{all_column_names.join("_")}_uniq"
            database.add_unique_constraint name, table, all_column_names, where: where, deferrable: deferrable, initially_deferred: initially_deferred, comment: comment
          end
        end
      end
    end
  end
end
