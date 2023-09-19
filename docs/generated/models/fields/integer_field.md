---
layout: default
title: Integer Field
parent: Fields
grand_parent: Models
has_children: false
has_toc: false
permalink: /models/fields/integer_field
---

# Integer Field
{: .no_toc }

Add an integer field to this model.

```ruby
class MyModel < PlatformModel
  # required arguments only
  integer_field :value
  # all possible arguments
  integer_field :value, array: false
end
```

#### Integer Field Arguments
{: .no_toc }

| Name | Required | Type | Description |
|:---|:---|:---|:---|
| name | required | Symbol | The name of your field. |
| array | optional | Boolean | If true, then this field will be an array of integers, and will be backed by an `integer[]` type in PostgreSQL. |

## Additional Configuration
{: .no_toc }

You can further configure the Integer Field by using the following methods:

- TOC
{:toc}


### Default

```ruby
class MyModel < PlatformModel
  integer_field :value do
    ...
    default 123
    ...
  end
end
```

#### Default Arguments
{: .no_toc }

| Name | Required | Type | Description |
|:---|:---|:---|:---|
| default | required | Integer |  |

### Allow Null

If true, then a null value is permitted for this field. This
is validated at the API level and with active record validations.
The underlying postgres column will also be configured to allow
NULL values

```ruby
class MyModel < PlatformModel
  integer_field :value do
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
  integer_field :value do
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
  integer_field :value do
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
  integer_field :value do
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
  integer_field :value do
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
  integer_field :value do
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

### Validate Greater Than

Ensure that the value provided to this field is greater than a
provided value. This will create an active record validation,
a database constraint and will be used in API validation and
generated documentation.

```ruby
class MyModel < PlatformModel
  integer_field :value do
    ...
    # required arguments only
    validate_greater_than 123
    # all possible arguments
    validate_greater_than 123, deferrable: false, initially_deferred: false, message: "message", comment: "comment"
    ...
  end
end
```

#### Validate Greater Than Arguments
{: .no_toc }

| Name | Required | Type | Description |
|:---|:---|:---|:---|
| value | required | Float | The value to validate against. The provided value must be greater than this value |
| deferrable | optional | Boolean | The enforcement of constraints occurs by default at the end of each SQL statement. Setting `deferrable: true` allows you to customize this behaviour and optionally enforce the unique constraint at the end of a transaction instead of after each statement. |
| initially_deferred | optional | Boolean | If true, then the default time to check the constraint will be at the end of the transaction rather than at the end of each statement.  Setting `initially_deferred: true` requires that this constraint is also marked as `deferrable: true`. |
| message | optional | String | The message which will be displayed if the validation fails. |
| comment | optional | String | A comment which explains the reason for this validation on this field. This will be used to generate documentation, and will be added as a comment to the database constraint. |

### Validate Greater Than Or Equal To

Ensure that the value provided to this field is greater than
or equal to a provided value. This will create an active record
validation, a database constraint and will be used in API
validation and generated documentation.

```ruby
class MyModel < PlatformModel
  integer_field :value do
    ...
    # required arguments only
    validate_greater_than_or_equal_to 123
    # all possible arguments
    validate_greater_than_or_equal_to 123, deferrable: false, initially_deferred: false, message: "message", comment: "comment"
    ...
  end
end
```

#### Validate Greater Than Or Equal To Arguments
{: .no_toc }

| Name | Required | Type | Description |
|:---|:---|:---|:---|
| value | required | Float | The value to validate against. The provided value must be greater than or equal to this value |
| deferrable | optional | Boolean | The enforcement of constraints occurs by default at the end of each SQL statement. Setting `deferrable: true` allows you to customize this behaviour and optionally enforce the unique constraint at the end of a transaction instead of after each statement. |
| initially_deferred | optional | Boolean | If true, then the default time to check the constraint will be at the end of the transaction rather than at the end of each statement.  Setting `initially_deferred: true` requires that this constraint is also marked as `deferrable: true`. |
| message | optional | String | The message which will be displayed if the validation fails. |
| comment | optional | String | A comment which explains the reason for this validation on this field. This will be used to generate documentation, and will be added as a comment to the database constraint. |

### Validate Less Than

Ensure that the value provided to this field is less than a
provided value. This will create an active record validation,
a database constraint and will be used in API validation and
generated documentation.

```ruby
class MyModel < PlatformModel
  integer_field :value do
    ...
    # required arguments only
    validate_less_than 123
    # all possible arguments
    validate_less_than 123, deferrable: false, initially_deferred: false, message: "message", comment: "comment"
    ...
  end
end
```

#### Validate Less Than Arguments
{: .no_toc }

| Name | Required | Type | Description |
|:---|:---|:---|:---|
| value | required | Float | The value to validate against. The provided value must be less than this value |
| deferrable | optional | Boolean | The enforcement of constraints occurs by default at the end of each SQL statement. Setting `deferrable: true` allows you to customize this behaviour and optionally enforce the unique constraint at the end of a transaction instead of after each statement. |
| initially_deferred | optional | Boolean | If true, then the default time to check the constraint will be at the end of the transaction rather than at the end of each statement.  Setting `initially_deferred: true` requires that this constraint is also marked as `deferrable: true`. |
| message | optional | String | The message which will be displayed if the validation fails. |
| comment | optional | String | A comment which explains the reason for this validation on this field. This will be used to generate documentation, and will be added as a comment to the database constraint. |

### Validate Less Than Or Equal To

Ensure that the value provided to this field is less than
or equal to a provided value. This will create an active record
validation, a database constraint and will be used in API
validation and generated documentation.

```ruby
class MyModel < PlatformModel
  integer_field :value do
    ...
    # required arguments only
    validate_less_than_or_equal_to 123
    # all possible arguments
    validate_less_than_or_equal_to 123, deferrable: false, initially_deferred: false, message: "message", comment: "comment"
    ...
  end
end
```

#### Validate Less Than Or Equal To Arguments
{: .no_toc }

| Name | Required | Type | Description |
|:---|:---|:---|:---|
| value | required | Float | The value to validate against. The provided value must be less than or equal to this value |
| deferrable | optional | Boolean | The enforcement of constraints occurs by default at the end of each SQL statement. Setting `deferrable: true` allows you to customize this behaviour and optionally enforce the unique constraint at the end of a transaction instead of after each statement. |
| initially_deferred | optional | Boolean | If true, then the default time to check the constraint will be at the end of the transaction rather than at the end of each statement.  Setting `initially_deferred: true` requires that this constraint is also marked as `deferrable: true`. |
| message | optional | String | The message which will be displayed if the validation fails. |
| comment | optional | String | A comment which explains the reason for this validation on this field. This will be used to generate documentation, and will be added as a comment to the database constraint. |

### Validate Equal To

Ensure that the value provided to this field is equal to a
provided value. This will create an active record validation,
a database constraint and will be used in API validation and
generated documentation.

```ruby
class MyModel < PlatformModel
  integer_field :value do
    ...
    # required arguments only
    validate_equal_to 123
    # all possible arguments
    validate_equal_to 123, deferrable: false, initially_deferred: false, message: "message", comment: "comment"
    ...
  end
end
```

#### Validate Equal To Arguments
{: .no_toc }

| Name | Required | Type | Description |
|:---|:---|:---|:---|
| value | required | Float | The value to validate against. The provided value must be equal to this value |
| deferrable | optional | Boolean | The enforcement of constraints occurs by default at the end of each SQL statement. Setting `deferrable: true` allows you to customize this behaviour and optionally enforce the unique constraint at the end of a transaction instead of after each statement. |
| initially_deferred | optional | Boolean | If true, then the default time to check the constraint will be at the end of the transaction rather than at the end of each statement.  Setting `initially_deferred: true` requires that this constraint is also marked as `deferrable: true`. |
| message | optional | String | The message which will be displayed if the validation fails. |
| comment | optional | String | A comment which explains the reason for this validation on this field. This will be used to generate documentation, and will be added as a comment to the database constraint. |

### Validate In

Ensure that the value provided to this field is equal to one of
the provided values. This will create an active record validation,
a database constraint and will be used in API validation and
generated documentation.

```ruby
class MyModel < PlatformModel
  integer_field :value do
    ...
    # required arguments only
    validate_in [123]
    # all possible arguments
    validate_in [123], deferrable: false, initially_deferred: false, message: "message", comment: "comment"
    ...
  end
end
```

#### Validate In Arguments
{: .no_toc }

| Name | Required | Type | Description |
|:---|:---|:---|:---|
| value | required | Array[Float] | The value or array of values to validate against. The provided value must be equal to one of these values. |
| deferrable | optional | Boolean | The enforcement of constraints occurs by default at the end of each SQL statement. Setting `deferrable: true` allows you to customize this behaviour and optionally enforce the unique constraint at the end of a transaction instead of after each statement. |
| initially_deferred | optional | Boolean | If true, then the default time to check the constraint will be at the end of the transaction rather than at the end of each statement.  Setting `initially_deferred: true` requires that this constraint is also marked as `deferrable: true`. |
| message | optional | String | The message which will be displayed if the validation fails. |
| comment | optional | String | A comment which explains the reason for this validation on this field. This will be used to generate documentation, and will be added as a comment to the database constraint. |

### Validate Not In

Ensure that the value provided to this field is not equal to one of
the provided values. This will create an active record validation,
a database constraint and will be used in API validation and
generated documentation.

```ruby
class MyModel < PlatformModel
  integer_field :value do
    ...
    # required arguments only
    validate_not_in [123]
    # all possible arguments
    validate_not_in [123], deferrable: false, initially_deferred: false, message: "message", comment: "comment"
    ...
  end
end
```

#### Validate Not In Arguments
{: .no_toc }

| Name | Required | Type | Description |
|:---|:---|:---|:---|
| value | required | Array[Float] | The value or array of values to validate against. The provided value must not be equal to any of these values. |
| deferrable | optional | Boolean | The enforcement of constraints occurs by default at the end of each SQL statement. Setting `deferrable: true` allows you to customize this behaviour and optionally enforce the unique constraint at the end of a transaction instead of after each statement. |
| initially_deferred | optional | Boolean | If true, then the default time to check the constraint will be at the end of the transaction rather than at the end of each statement.  Setting `initially_deferred: true` requires that this constraint is also marked as `deferrable: true`. |
| message | optional | String | The message which will be displayed if the validation fails. |
| comment | optional | String | A comment which explains the reason for this validation on this field. This will be used to generate documentation, and will be added as a comment to the database constraint. |

### Zero To Null

Ensures that the value of this field can not be the number 0.
If it is the number 0, then it will be converted automatically
to null. This coercion logic will be installed into active record,
and a constraint will be added to the database to ensure there are
no 0 values. If used on an array field, then vaues of 0 will be
automatically removed from the array and the database constraint will
forbid any arrays with a value of 0.

```ruby
class MyModel < PlatformModel
  integer_field :value do
    ...
    # required arguments only
    zero_to_null 
    # all possible arguments
    zero_to_null comment: "comment"
    ...
  end
end
```

#### Zero To Null Arguments
{: .no_toc }

| Name | Required | Type | Description |
|:---|:---|:---|:---|
| comment | optional | String | A comment which explains the reason for converting 0 to null on this field. This will be used to generate documentation, and will be added as a comment to the database constraint. |

### Remove Null Array Values

Ensures that the value of this field does not contain any null values.
Any null values will automatically be removed before saving the record.
This coercion logic will be installed into active record. A validation
will also be added to the database to assert that the column has no
null values. This is only compatibile with array fields.

```ruby
class MyModel < PlatformModel
  integer_field :value do
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

### Validate Even

Ensure that the value provided to this field is even. This will
create an active record validation, a database constraint and
will be used in API validation and generated documentation.

```ruby
class MyModel < PlatformModel
  integer_field :value do
    ...
    # required arguments only
    validate_even 
    # all possible arguments
    validate_even message: "message"
    ...
  end
end
```

#### Validate Even Arguments
{: .no_toc }

| Name | Required | Type | Description |
|:---|:---|:---|:---|
| message | optional | String | The message which will be raised if the validation fails. |

### Validate Odd

Ensure that the value provided to this field is odd. This will
create an active record validation, a database constraint and
will be used in API validation and generated documentation.

```ruby
class MyModel < PlatformModel
  integer_field :value do
    ...
    # required arguments only
    validate_odd 
    # all possible arguments
    validate_odd message: "message"
    ...
  end
end
```

#### Validate Odd Arguments
{: .no_toc }

| Name | Required | Type | Description |
|:---|:---|:---|:---|
| message | optional | String | The message which will be raised if the validation fails. |