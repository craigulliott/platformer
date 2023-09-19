---
layout: default
title: Uuid Field
parent: Fields
grand_parent: Models
has_children: false
has_toc: false
permalink: /models/fields/uuid_field
---

# Uuid Field
{: .no_toc }

Add a field to this model for storing IPv4 and IPv6 hosts and networks.

```ruby
class MyModel < PlatformModel
  # required arguments only
  uuid_field :value
  # all possible arguments
  uuid_field :value, array: false
end
```

#### Uuid Field Arguments
{: .no_toc }

| Name | Required | Type | Description |
|:---|:---|:---|:---|
| name | required | Symbol | The name of your field. |
| array | optional | Boolean | If true, then this field will be an array of uuids, and will be backed by a `uuid[]` type in PostgreSQL. |

## Additional Configuration
{: .no_toc }

You can further configure the Uuid Field by using the following methods:

- TOC
{:toc}


### Default

```ruby
class MyModel < PlatformModel
  uuid_field :value do
    ...
    default "default"
    ...
  end
end
```

#### Default Arguments
{: .no_toc }

| Name | Required | Type | Description |
|:---|:---|:---|:---|
| default | required | String |  |

### Allow Null

If true, then a null value is permitted for this field. This
is validated at the API level and with active record validations.
The underlying postgres column will also be configured to allow
NULL values

```ruby
class MyModel < PlatformModel
  uuid_field :value do
    ...
    allow_null 
    ...
  end
end
```

### Empty Array To Null

Ensures that the value of this field can not be an empty Array. If
at empty object is provided then it will automatically be converted
to NULL. This coercion logic will be installed into active record.
A validation will also be added to the database to assert that this
coercion was applied to any records before they are attempted to be
saved. This can be used in conjunction with `allow_null: false` to
make an array with at least one item a requirement. This can only be
used on fields which have been set to `array: true`.

```ruby
class MyModel < PlatformModel
  uuid_field :value do
    ...
    # required arguments only
    empty_array_to_null 
    # all possible arguments
    empty_array_to_null comment: "comment"
    ...
  end
end
```

#### Empty Array To Null Arguments
{: .no_toc }

| Name | Required | Type | Description |
|:---|:---|:---|:---|
| comment | optional | String | A comment which explains the reason for adding coercing empty arrays to null on this field. This will be used to generate documentation, and will be added as a comment to the database constraint. |

### Unique

If used within a field dsl then this will enforce uniqueness for this
field.

```ruby
class MyModel < PlatformModel
  uuid_field :value do
    ...
    # required arguments only
    unique 
    # all possible arguments
    unique deferrable: false, initially_deferred: false, where: "where", scope: [:value], message: "message", comment: "comment"
    ...
  end
end
```

#### Unique Arguments
{: .no_toc }

| Name | Required | Type | Description |
|:---|:---|:---|:---|
| deferrable | optional | Boolean | The enforcement of constraints occurs by default at the end of each SQL statement. Setting `deferrable: true` allows you to customize this behaviour and optionally enforce the unique constraint at the end of a transaction instead of after each statement. |
| initially_deferred | optional | Boolean | If true, then the default time to check the constraint will be at the end of the transaction rather than at the end of each statement.  Setting `initially_deferred: true` requires that this constraint is also marked as `deferrable: true`. |
| where | optional | String | An optional SQL condition which can be used to limit this uniqueness to a subset of records. If you provide a value for where, then it is not possible to set 'deferrable: true', this is because the underlying constraint will be enforced by a unique index rather than a unique_contraint, and indexes can not be deferred in postgres. |
| scope | optional | Array[Symbol] | An optional list of fields which will be used to scope the uniqueness constraint for this field. |
| message | optional | String | The message which will be displayed if the validation fails. |
| comment | optional | String | A comment which explains the reason for uniqueness on this field. This will be used to generate documentation, and error messages |

### Comment

This method is used to describe a specific use of this
field within a model, this description will be added to
the database column as a comment, and will be used to
generate API documentation.

```ruby
class MyModel < PlatformModel
  uuid_field :value do
    ...
    comment "comment"
    ...
  end
end
```

#### Comment Arguments
{: .no_toc }

| Name | Required | Type | Description |
|:---|:---|:---|:---|
| comment | required | String | The description of this field |

### Immutable

Ensures that the value of this field can not be changed
after it is initially created. This will create an active
record validation, a database constraint and will be used
in API validation and generated documentation.

```ruby
class MyModel < PlatformModel
  uuid_field :value do
    ...
    # required arguments only
    immutable 
    # all possible arguments
    immutable message: "message"
    ...
  end
end
```

#### Immutable Arguments
{: .no_toc }

| Name | Required | Type | Description |
|:---|:---|:---|:---|
| message | optional | String | The message which will be raised if the validation fails. |

### Immutable Once Set

Ensures that the value of this field can not be changed
after it is has been set. This means that the value can
initially be set to null, and can remain as null for some
time, but if the field is ever provided with a value then
it will be immutable thereafter. This will create an active
record validation, a database constraint and will be used
in API validation and generated documentation.

```ruby
class MyModel < PlatformModel
  uuid_field :value do
    ...
    # required arguments only
    immutable_once_set 
    # all possible arguments
    immutable_once_set message: "message"
    ...
  end
end
```

#### Immutable Once Set Arguments
{: .no_toc }

| Name | Required | Type | Description |
|:---|:---|:---|:---|
| message | optional | String | The message which will be raised if the validation fails. |

### Remove Null Array Values

Ensures that the value of this field does not contain any null values.
Any null values will automatically be removed before saving the record.
This coercion logic will be installed into active record. A validation
will also be added to the database to assert that the column has no
null values. This is only compatibile with array fields.

```ruby
class MyModel < PlatformModel
  uuid_field :value do
    ...
    # required arguments only
    remove_null_array_values 
    # all possible arguments
    remove_null_array_values comment: "comment"
    ...
  end
end
```

#### Remove Null Array Values Arguments
{: .no_toc }

| Name | Required | Type | Description |
|:---|:---|:---|:---|
| comment | optional | String | A comment which explains the reason for automatically removing any null values from this field. This will be used to generate documentation, and will be added as a comment to the database constraint. |