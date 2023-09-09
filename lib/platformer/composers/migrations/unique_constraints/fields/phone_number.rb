# frozen_string_literal: true

module Platformer
  module Composers
    module Migrations
      # Add all unique constraints to their respective columns within DynamicMigrations
      class UniqueConstraints < Parsers::FinalModels::ForFields
        class WhereCanNotBeUsedWithDeferrableError < StandardError
        end

        for_field :phone_number_field do |dsl_name:, prefix:, table:, database:, comment_text:, allow_null:|
          # if the unique method was used within our field DSL
          for_method :unique do |scope:, comment:, where:, deferrable:, initially_deferred:|
            name_prepend = prefix.nil? ? "" : "#{prefix}_"
            column_names = [:"#{name_prepend}dialing_code", :"#{name_prepend}phone_number"] + scope
            name = "#{name_prepend}phone_number_uniq"
            database.add_unique_constraint name, table, column_names, where: where, deferrable: deferrable, initially_deferred: initially_deferred, comment: comment_text
          end
        end
      end
    end
  end
end
