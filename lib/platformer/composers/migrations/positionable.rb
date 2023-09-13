# frozen_string_literal: true

module Platformer
  module Composers
    module Migrations
      class Positionable < Parsers::FinalModels
        class MissingStatesError < StandardError
        end

        for_dsl :positionable do |schema:, table:, database:, scope:, reader:|
          comment = reader.comment&.comment

          # update the dynamic documentation
          add_documentation <<~DESCRIPTION
            And add an integer column named `:position` to the
            `#{table.schema.name}'.'#{table.name}` table. This column is used to
            allow manual sorting of records within this table. The column
            can never be NULL.
          DESCRIPTION

          scope_description = if scope.any?
            <<~DESCRIPTION
              The position of this record is kept unique, and scoped to the columns
              #{scope.to_sentence}.
            DESCRIPTION
          else
            <<~DESCRIPTION
              No scope was provided, so the position of this record is unique across
              all other records in this table.
            DESCRIPTION
          end

          add_documentation scope_description

          # add the column to the DynamicMigrations table
          column = table.add_column :position, :integer, null: false, description: <<~COMMENT
            #{comment}
            This column represents the current position of this manually sortable record.
            #{scope_description}
          COMMENT

          # add a validation to ensure manually set position values are always greater than 0
          add_documentation <<~DESCRIPTION
            Add a validation to the `#{column.table.schema.name}'.'#{column.table.name}` table
            to assert that any values provided to the position value are always greater than 0.
            #{scope_description}
            This constraint is not deferrable.
          DESCRIPTION

          validation_name = :valid_position_value

          # add the validation to the table
          check_clause = <<~SQL
            #{column.name} > 0
          SQL
          table.add_validation validation_name, [column.name], check_clause, deferrable: false, initially_deferred: false, description: comment

          # add a deferrable unique constraint for the position of this model and its provided scope
          add_documentation <<~DESCRIPTION
            Add an initially deferred unique constraint to the (`#{table.schema.name}'.'#{table.name}`) table
            to enforce that the manually set position of this models is unique when scoped to #{scope.any? ? scope.to_sentence : "no other columnns"}.
          DESCRIPTION

          # add the unique constraint to the table
          unique_constraint_name = :positionable_uniq
          all_column_names = scope + [:position]
          table.add_unique_constraint unique_constraint_name, all_column_names, deferrable: true, initially_deferred: true, description: comment
        end
      end
    end
  end
end
