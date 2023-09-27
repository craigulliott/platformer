module Platformer
  module DSLs
    module Models
      module SoftDeletable
        def self.included klass
          klass.define_dsl :soft_deletable do
            description <<~DESCRIPTION
              This DSL allows you to add soft delete functionality to your model. Soft delete
              functionality allows you to delete a record from the database without actually
              deleting it. This is useful for situations where you want to retain the record
              or provide functionality to undelete it again.

              From a systems perspective, the implememntation of this functionality is almost
              exactly the same as an Action Field. This is backed by two database columnns, one
              is a boolean column called `undeleted` and the other is a timestamp called `deleted_at`.
              Initially `:undeleted` is TRUE and `:deleted_at` is NULL. When the`delete` action occurs,
              `:undeleted` is set to NULL and `:deleted_at` is set to the current time. This schema
              ensures that one of the columns is always NULL and the other always has a value, which
              allows for the most flexibility when adding database constraints and indexes. For example,
              you can add a unique index with columns which include the boolean column to ensure that a
              user has only one undeleted version of a specific model at a time.
            DESCRIPTION

            optional :undeletable, :boolean do
              description <<~DESCRIPTION
                If true, then this record can be recovered/undeleted again. If false (the default) then
                the delete is permenant from a user perspective, but the record will still persist in the
                database.
              DESCRIPTION
            end
          end
        end
      end
    end
  end
end
