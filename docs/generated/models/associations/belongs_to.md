---
layout: default
title: Belongs To
parent: Associations
grand_parent: Models
has_children: false
---

Specifies a one-to-one association with another class. This will
automatically create the appropriate foreign key column on this
model, build the appropriate foreign key constraint and setup
the ActiveRecord associations.

```ruby
class My::BaseModel < Platformer::BaseModel
  belongs_to "Foreign Model"
end

```

**Arguments**

foreign\_model (required Class)
:   The Model class which this Model belongs to.

as (optional Symbol)
:   An optional name for this association, if a name is not provided then a default will be used based off the name of the foreign model.

local\_column\_names (optional [Symbol])
:   Override the default behaviour of generating a new column on this model, and specify the name of one or more existing columns to use instead.

foreign\_column\_names (optional [Symbol])
:   The name of one or more existing columns on the other (foreign) model which make up the other side of this relationnship.

comment (optional String)
:   A comment which explains the reason for this association on this model. This will be used to generate documentation, and will be added as a comment to the database constraint.

deferrable (optional Boolean)
:   The enforcement of constraints occurs by default at the end of each SQL statement. Setting `deferrable: true` allows you to customize this behaviour and optionally enforce the unique constraint at the end of a transaction instead of after each statement.

initially\_deferred (optional Boolean)
:   If true, then the default time to check the constraint will be at the end of the transaction rather than at the end of each statement.  Setting `initially\_deferred: true` requires that this constraint is also marked as `deferrable: true`.

on\_update (optional Symbol)
:   Configure how to handle the record in the local table when the foreign row it is constrainted to is updated. The default is `:restrict` but the possible values are: options are.  `:no\_action`  produce an error indicating that the deletion or update would create a foreign key constraint violation. If the constraint is deferred, this error will be produced at constraint check time if there still exist any referencing rows. This is the default action.  `:restrict`  Produce an error indicating that the deletion or update would create a foreign key constraint violation. This is the same as NO ACTION except that the check is not deferrable.  `:cascade`  Delete any rows referencing the deleted row, or update the values of the referencing column(s) to the new values of the referenced columns, respectively.  `:set\_null`  Set all of the referencing columns, or a specified subset of the referencing columns, to null.  `:set\_default`  Set all of the referencing columns, or a specified subset of the referencing columns, to their default values.

on\_delete (optional Symbol)
:   Configure how to handle the record in the local table when the foreign row it is constrainted to is deleted. The default is `:restrict` but the possible values are: options are.  `:no\_action`  produce an error indicating that the deletion or update would create a foreign key constraint violation. If the constraint is deferred, this error will be produced at constraint check time if there still exist any referencing rows. This is the default action.  `:restrict`  Produce an error indicating that the deletion or update would create a foreign key constraint violation. This is the same as NO ACTION except that the check is not deferrable.  `:cascade`  Delete any rows referencing the deleted row, or update the values of the referencing column(s) to the new values of the referenced columns, respectively.  `:set\_null`  Set all of the referencing columns, or a specified subset of the referencing columns, to null.  `:set\_default`  Set all of the referencing columns, or a specified subset of the referencing columns, to their default values.

**Additional Configuration Options**

**Allow Null**

If true, and `local_column_names` were not provided, then the
automatically generated column which is added to the local
table can be `null`, which makes the `belongs_to` association optional.

```ruby
class My::BaseModel < Platform::BaseModel
  belongs_to "Foreign Model" do
    ...
    allow_null "Foreign Model", as: :as, local_column_names: [:local_column_names], foreign_column_names: [:foreign_column_names], comment: comment, deferrable: deferrable, initially_deferred: initially_deferred, on_update: :on_update, on_delete: :on_delete
    ...
  end
end

```