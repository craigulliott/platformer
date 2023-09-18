---
layout: default
title: Has Many
parent: Associations
grand_parent: Models
has_children: false
---

Specifies a one-to-many association with another class. This will
automatically create the appropriate foreign key column on the other
model, build the appropriate foreign key constraint and setup
the ActiveRecord associations.

```ruby
class My::BaseModel < Platformer::BaseModel
  has_many "Foreign Model"
end

```

**Arguments**

foreign\_model (required Class)
:   The Model class which this Model has many of.

as (optional Symbol)
:   An optional name for this association, if a name is not provided then a default will be used based off the name of the foreign model.

local\_column\_names (optional [Symbol])
:   The name of one or more existing columns on the this model which make up this side of association. If this is ommited then the default column name `id` is assumed.

foreign\_column\_names (optional [Symbol])
:   Override the default behaviour of generating a new column on the foreign model, and specify the name of one or more existing columns to use instead.

comment (optional String)
:   A comment which explains the reason for this association on this model. This will be used to generate documentation, and will be added as a comment to the database constraint.

deferrable (optional Boolean)
:   The enforcement of constraints occurs by default at the end of each SQL statement. Setting `deferrable: true` allows you to customize this behaviour and optionally enforce the unique constraint at the end of a transaction instead of after each statement.

initially\_deferred (optional Boolean)
:   If true, then the default time to check the constraint will be at the end of the transaction rather than at the end of each statement.  Setting `initially\_deferred: true` requires that this constraint is also marked as `deferrable: true`.

on\_update (optional Symbol)
:   Configure how to handle the record in the remote table when the local row is updated. The default is `:restrict` but the possible values are:  `:no\_action`  produce an error indicating that the deletion or update would create a foreign key constraint violation. If the constraint is deferred, this error will be produced at constraint check time if there still exist any referencing rows. This is the default action.  `:restrict`  Produce an error indicating that the deletion or update would create a foreign key constraint violation. This is the same as NO ACTION except that the check is not deferrable.  `:cascade`  Delete any rows referencing the deleted row, or update the values of the referencing column(s) to the new values of the referenced columns, respectively.  `:set\_null`  Set all of the referencing columns, or a specified subset of the referencing columns, to null.  `:set\_default`  Set all of the referencing columns, or a specified subset of the referencing columns, to their default values.

on\_delete (optional Symbol)
:   Configure how to handle the record in the remote table when the local is deleted. The default is `:restrict` but the possible values are:  `:no\_action`  produce an error indicating that the deletion or update would create a foreign key constraint violation. If the constraint is deferred, this error will be produced at constraint check time if there still exist any referencing rows. This is the default action.  `:restrict`  Produce an error indicating that the deletion or update would create a foreign key constraint violation. This is the same as NO ACTION except that the check is not deferrable.  `:cascade`  Delete any rows referencing the deleted row, or update the values of the referencing column(s) to the new values of the referenced columns, respectively.  `:set\_null`  Set all of the referencing columns, or a specified subset of the referencing columns, to null.  `:set\_default`  Set all of the referencing columns, or a specified subset of the referencing columns, to their default values.

**Additional Configuration Options**

**Allow Null**

If true, and `foreign_column_names` were not provided, then the
automatically generated column which is added to the foreign
table can be `null`, which makes it's association back to this local
model optional.

```ruby
class My::BaseModel < Platform::BaseModel
  has_many "Foreign Model" do
    ...
    allow_null "Foreign Model", as: :as, local_column_names: [:local_column_names], foreign_column_names: [:foreign_column_names], comment: comment, deferrable: deferrable, initially_deferred: initially_deferred, on_update: :on_update, on_delete: :on_delete
    ...
  end
end

```