---
layout: default
title: Belongs To
parent: Associations
grand_parent: Models
has_children: false
has_toc: false
permalink: /models/associations/belongs_to
---

# Belongs To
{: .no_toc }

Specifies a one-to-one association with another class. This will
automatically create the appropriate foreign key column on this
model, build the appropriate foreign key constraint and setup
the ActiveRecord associations.

```ruby
class MyModel < PlatformModel
  # required arguments only
  belongs_to "ForeignModel"
  # all possible arguments
  belongs_to "ForeignModel", as: :value, local_column_names: [:value], foreign_column_names: [:value], comment: "comment", deferrable: false, initially_deferred: false, on_update: :value, on_delete: :value
end
```

#### Belongs To Arguments
{: .no_toc }

| Name | Required | Type | Description |
|:---|:---|:---|:---|
| foreign_model | required | Class | The Model class which this Model belongs to. |
| as | optional | Symbol | An optional name for this association, if a name is not provided then a default will be used based off the name of the foreign model. |
| local_column_names | optional | Array[Symbol] | Override the default behaviour of generating a new column on this model, and specify the name of one or more existing columns to use instead. |
| foreign_column_names | optional | Array[Symbol] | The name of one or more existing columns on the other (foreign) model which make up the other side of this relationnship. |
| comment | optional | String | A comment which explains the reason for this association on this model. This will be used to generate documentation, and will be added as a comment to the database constraint. |
| deferrable | optional | Boolean | The enforcement of constraints occurs by default at the end of each SQL statement. Setting `deferrable: true` allows you to customize this behaviour and optionally enforce the unique constraint at the end of a transaction instead of after each statement. |
| initially_deferred | optional | Boolean | If true, then the default time to check the constraint will be at the end of the transaction rather than at the end of each statement.  Setting `initially_deferred: true` requires that this constraint is also marked as `deferrable: true`. |
| on_update | optional | `:no_action`, `:restrict`, `:cascade`, `:set_null` or `:set_default` | Configure how to handle the record in the local table when the foreign row it is constrainted to is updated. The default is `:restrict` but the possible values are: options are.  `:no_action`  produce an error indicating that the deletion or update would create a foreign key constraint violation. If the constraint is deferred, this error will be produced at constraint check time if there still exist any referencing rows. This is the default action.  `:restrict`  Produce an error indicating that the deletion or update would create a foreign key constraint violation. This is the same as NO ACTION except that the check is not deferrable.  `:cascade`  Delete any rows referencing the deleted row, or update the values of the referencing column(s) to the new values of the referenced columns, respectively.  `:set_null`  Set all of the referencing columns, or a specified subset of the referencing columns, to null.  `:set_default`  Set all of the referencing columns, or a specified subset of the referencing columns, to their default values. |
| on_delete | optional | `:no_action`, `:restrict`, `:cascade`, `:set_null` or `:set_default` | Configure how to handle the record in the local table when the foreign row it is constrainted to is deleted. The default is `:restrict` but the possible values are: options are.  `:no_action`  produce an error indicating that the deletion or update would create a foreign key constraint violation. If the constraint is deferred, this error will be produced at constraint check time if there still exist any referencing rows. This is the default action.  `:restrict`  Produce an error indicating that the deletion or update would create a foreign key constraint violation. This is the same as NO ACTION except that the check is not deferrable.  `:cascade`  Delete any rows referencing the deleted row, or update the values of the referencing column(s) to the new values of the referenced columns, respectively.  `:set_null`  Set all of the referencing columns, or a specified subset of the referencing columns, to null.  `:set_default`  Set all of the referencing columns, or a specified subset of the referencing columns, to their default values. |

## Additional Configuration
{: .no_toc }

You can further configure the Belongs To by using the following methods:

### Allow Null

If true, and `local_column_names` were not provided, then the
automatically generated column which is added to the local
table can be `null`, which makes the `belongs_to` association optional.

```ruby
class MyModel < PlatformModel
  belongs_to "ForeignModel" do
    ...
    allow_null 
    ...
  end
end
```