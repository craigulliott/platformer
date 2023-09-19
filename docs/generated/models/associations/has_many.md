---
layout: default
title: Has Many
parent: Associations
grand_parent: Models
has_children: false
has_toc: false
permalink: /models/associations/has_many
---

# Has Many
{: .no_toc }

Specifies a one-to-many association with another class. This will
automatically create the appropriate foreign key column on the other
model, build the appropriate foreign key constraint and setup
the ActiveRecord associations.

```ruby
class MyModel < PlatformModel
  # required arguments only
  has_many "ForeignModel"
  # all possible arguments
  has_many "ForeignModel", as: :value, local_column_names: [:value], foreign_column_names: [:value], comment: "comment", deferrable: false, initially_deferred: false, on_update: :value, on_delete: :value
end
```

#### Has Many Arguments
{: .no_toc }

| Name | Required | Type | Description |
|:---|:---|:---|:---|
| foreign_model | required | Class | The Model class which this Model has many of. |
| as | optional | Symbol | An optional name for this association, if a name is not provided then a default will be used based off the name of the foreign model. |
| local_column_names | optional | Array[Symbol] | The name of one or more existing columns on the this model which make up this side of association. If this is ommited then the default column name `id` is assumed. |
| foreign_column_names | optional | Array[Symbol] | Override the default behaviour of generating a new column on the foreign model, and specify the name of one or more existing columns to use instead. |
| comment | optional | String | A comment which explains the reason for this association on this model. This will be used to generate documentation, and will be added as a comment to the database constraint. |
| deferrable | optional | Boolean | The enforcement of constraints occurs by default at the end of each SQL statement. Setting `deferrable: true` allows you to customize this behaviour and optionally enforce the unique constraint at the end of a transaction instead of after each statement. |
| initially_deferred | optional | Boolean | If true, then the default time to check the constraint will be at the end of the transaction rather than at the end of each statement.  Setting `initially_deferred: true` requires that this constraint is also marked as `deferrable: true`. |
| on_update | optional | `:no_action`, `:restrict`, `:cascade`, `:set_null` or `:set_default` | Configure how to handle the record in the remote table when the local row is updated. The default is `:restrict` but the possible values are:  `:no_action`  produce an error indicating that the deletion or update would create a foreign key constraint violation. If the constraint is deferred, this error will be produced at constraint check time if there still exist any referencing rows. This is the default action.  `:restrict`  Produce an error indicating that the deletion or update would create a foreign key constraint violation. This is the same as NO ACTION except that the check is not deferrable.  `:cascade`  Delete any rows referencing the deleted row, or update the values of the referencing column(s) to the new values of the referenced columns, respectively.  `:set_null`  Set all of the referencing columns, or a specified subset of the referencing columns, to null.  `:set_default`  Set all of the referencing columns, or a specified subset of the referencing columns, to their default values. |
| on_delete | optional | `:no_action`, `:restrict`, `:cascade`, `:set_null` or `:set_default` | Configure how to handle the record in the remote table when the local is deleted. The default is `:restrict` but the possible values are:  `:no_action`  produce an error indicating that the deletion or update would create a foreign key constraint violation. If the constraint is deferred, this error will be produced at constraint check time if there still exist any referencing rows. This is the default action.  `:restrict`  Produce an error indicating that the deletion or update would create a foreign key constraint violation. This is the same as NO ACTION except that the check is not deferrable.  `:cascade`  Delete any rows referencing the deleted row, or update the values of the referencing column(s) to the new values of the referenced columns, respectively.  `:set_null`  Set all of the referencing columns, or a specified subset of the referencing columns, to null.  `:set_default`  Set all of the referencing columns, or a specified subset of the referencing columns, to their default values. |

## Additional Configuration
{: .no_toc }

You can further configure the Has Many by using the following methods:

### Allow Null

If true, and `foreign_column_names` were not provided, then the
automatically generated column which is added to the foreign
table can be `null`, which makes it's association back to this local
model optional.

```ruby
class MyModel < PlatformModel
  has_many "ForeignModel" do
    ...
    allow_null 
    ...
  end
end
```