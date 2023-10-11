# frozen_string_literal: true

module Platformer
  module Databases
    module Postgres
      class Server
        class Database
          module Composers
            module AddUniqueConstraint
              def add_unique_constraint name, table, column_names, where: nil, deferrable: false, initially_deferred: false, description: nil
                # If you provide a value for where, then it is not possible to
                # set 'deferrable: true', this is because the underlying constraint
                # will be enforced by a unique index rather than a contraint, and
                # indexes can not be deferred in postgres.
                if where && deferrable
                  raise WhereCanNotBeUsedWithDeferrableError, "If you provide a where clause to a unique constraint, then deferrable must be set to false"
                end

                # if a where was provided, then we must use a unique index rather than a unique constraint
                if where
                  table.add_index name, column_names, unique: true, where: where, description: description
                else
                  # add the unique constraint to the table
                  table.add_unique_constraint name, column_names, deferrable: deferrable, initially_deferred: initially_deferred, description: description
                end
              end
            end
          end
        end
      end
    end
  end
end
