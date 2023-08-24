module Platformer
  module DSLs
    module Models
      module Associations
        module Shared
          module ReferentialActionDescription
            DESCRIPTION = <<~DESCRIPTION
              `:no_action`

              produce an error indicating that the deletion or update would create a
              foreign key constraint violation. If the constraint is deferred, this
              error will be produced at constraint check time if there still exist
              any referencing rows. This is the default action.

              `:restrict`

              Produce an error indicating that the deletion or update would create a
              foreign key constraint violation. This is the same as NO ACTION except
              that the check is not deferrable.

              `:cascade`

              Delete any rows referencing the deleted row, or update the values of
              the referencing column(s) to the new values of the referenced columns,
              respectively.

              `:set_null`

              Set all of the referencing columns, or a specified subset of the
              referencing columns, to null.

              `:set_default`

              Set all of the referencing columns, or a specified subset of the
              referencing columns, to their default values.
            DESCRIPTION
          end
        end
      end
    end
  end
end
