---
layout: default
title: Json Field
parent: Fields
grand_parent: Models
has_children: false
has_toc: false
permalink: /models/fields/json_field
---

Add a json field to this model.

```ruby
class MyModel < PlatformerModel
  json_field :name
end
```

**Arguments**

| Name | Required | Type | Description |
|:---|:---|:---|:---|
| name | required | Symbol | The name of your field. |

**Additional Configuration Options**

**Empty Json To Null**

Ensures that the value of this field can not be an empty json object.
If it is an empty json object, then it will be converted automatically
to null. This coercion logic will be installed into active record,
the API and the database as a stored procedure.

```ruby
class MyModel < PlatformModel
  json_field :name do
    ...
    empty_json_to_null :name
    ...
  end
end
```

**Arguments**

| Name | Required | Type | Description |
|:---|:---|:---|:---|
| comment | optional | String | A comment which explains the reason for adding coercing empty arrays to null on this field. This will be used to generate documentation, and will be added as a comment to the database constraint. |

**Default**

```ruby
class MyModel < PlatformModel
  json_field :name do
    ...
    default :name
    ...
  end
end
```

**Arguments**

| Name | Required | Type | Description |
|:---|:---|:---|:---|
| default | required | String |  |

**Allow Null**

If true, then a null value is permitted for this field. This
is validated at the API level and with active record validations.
The underlying postgres column will also be configured to allow
NULL values

```ruby
class MyModel < PlatformModel
  json_field :name do
    ...
    allow_null :name
    ...
  end
end
```

**Comment**

This method is used to describe a specific use of this
field within a model, this description will be added to
the database column as a comment, and will be used to
generate API documentation.

```ruby
class MyModel < PlatformModel
  json_field :name do
    ...
    comment :name
    ...
  end
end
```

**Arguments**

| Name | Required | Type | Description |
|:---|:---|:---|:---|
| comment | required | String | The description of this field |

**Immutable**

Ensures that the value of this field can not be changed
after it is initially created. This will create an active
record validation, a database constraint and will be used
in API validation and generated documentation.

```ruby
class MyModel < PlatformModel
  json_field :name do
    ...
    immutable :name
    ...
  end
end
```

**Arguments**

| Name | Required | Type | Description |
|:---|:---|:---|:---|
| message | optional | String | The message which will be raised if the validation fails. |

**Immutable Once Set**

Ensures that the value of this field can not be changed
after it is has been set. This means that the value can
initially be set to null, and can remain as null for some
time, but if the field is ever provided with a value then
it will be immutable thereafter. This will create an active
record validation, a database constraint and will be used
in API validation and generated documentation.

```ruby
class MyModel < PlatformModel
  json_field :name do
    ...
    immutable_once_set :name
    ...
  end
end
```

**Arguments**

| Name | Required | Type | Description |
|:---|:---|:---|:---|
| message | optional | String | The message which will be raised if the validation fails. |

**Unique**

If used within a field dsl then this will enforce uniqueness for this
field.

```ruby
class MyModel < PlatformModel
  json_field :name do
    ...
    unique :name
    ...
  end
end
```

**Arguments**

| Name | Required | Type | Description |
|:---|:---|:---|:---|
| deferrable | optional | Boolean | The enforcement of constraints occurs by default at the end of each SQL statement. Setting `deferrable: true` allows you to customize this behaviour and optionally enforce the unique constraint at the end of a transaction instead of after each statement. |
| initially_deferred | optional | Boolean | If true, then the default time to check the constraint will be at the end of the transaction rather than at the end of each statement.  Setting `initially_deferred: true` requires that this constraint is also marked as `deferrable: true`. |
| where | optional | String | An optional SQL condition which can be used to limit this uniqueness to a subset of records. If you provide a value for where, then it is not possible to set 'deferrable: true', this is because the underlying constraint will be enforced by a unique index rather than a unique_contraint, and indexes can not be deferred in postgres. |
| scope | optional | Array[Symbol] | An optional list of fields which will be used to scope the uniqueness constraint for this field. |
| message | optional | String | The message which will be displayed if the validation fails. |
| comment | optional | String | A comment which explains the reason for uniqueness on this field. This will be used to generate documentation, and error messages |