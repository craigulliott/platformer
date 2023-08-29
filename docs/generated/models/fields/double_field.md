Add a double field to this model.

```ruby
class MyModel < PlatformModel
  double_field :name
end

```

**Arguments**

name (required Symbol)
:   The name of this double field

array (optional Boolean)
:   If true, then this field will be an array of doubles, and will be backed by a `double precision[]` type in PostgreSQL.

**Additional Configuration Options**

**Default**

```ruby
class MyModel < PlatformModel
  double_field :name do
    ...
    default :name, array: array
    ...
  end
end

```

**Arguments**

default (required Float)
:   

**Allow Null**

If true, then a null value is permitted for this field. This
is validated at the API level and with active record validations.
The underlying postgres column will also be configured to allow
NULL values

```ruby
class MyModel < PlatformModel
  double_field :name do
    ...
    allow_null :name, array: array
    ...
  end
end

```

**Empty Array To Null**

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
  double_field :name do
    ...
    empty_array_to_null :name, array: array
    ...
  end
end

```

**Arguments**

comment (optional String)
:   A comment which explains the reason for adding coercing empty arrays to null on this field. This will be used to generate documentation, and will be added as a comment to the database constraint.

**Unique**

If used within a field dsl then this will enforce uniqueness for this
field.

```ruby
class MyModel < PlatformModel
  double_field :name do
    ...
    unique :name, array: array
    ...
  end
end

```

**Arguments**

deferrable (optional Boolean)
:   The enforcement of constraints occurs by default at the end of each SQL statement. Setting `deferrable: true` allows you to customize this behaviour and optionally enforce the unique constraint at the end of a transaction instead of after each statement.

initially\_deferred (optional Boolean)
:   If true, then the default time to check the constraint will be at the end of the transaction rather than at the end of each statement.  Setting `initially\_deferred: true` requires that this constraint is also marked as `deferrable: true`.

where (optional String)
:   An optional SQL condition which can be used to limit this uniqueness to a subset of records. If you provide a value for where, then it is not possible to set 'deferrable: true', this is because the underlying constraint will be enforced by a unique index rather than a unique\_contraint, and indexes can not be deferred in postgres.

scope (optional [Symbol])
:   An optional list of fields which will be used to scope the uniqueness constraint for this field.

message (optional String)
:   The message which will be displayed if the validation fails.

comment (optional String)
:   A comment which explains the reason for uniqueness on this field. This will be used to generate documentation, and error messages

**Comment**

This method is used to describe a specific use of this
field within a model, this description will be added to
the database column as a comment, and will be used to
generate API documentation.

```ruby
class MyModel < PlatformModel
  double_field :name do
    ...
    comment :name, array: array
    ...
  end
end

```

**Arguments**

comment (required String)
:   The description of this field

**Immutable**

Ensures that the value of this field can not be changed
after it is initially created. This will create an active
record validation, a database constraint and will be used
in API validation and generated documentation.

```ruby
class MyModel < PlatformModel
  double_field :name do
    ...
    immutable :name, array: array
    ...
  end
end

```

**Arguments**

message (optional String)
:   The message which will be raised if the validation fails.

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
  double_field :name do
    ...
    immutable_once_set :name, array: array
    ...
  end
end

```

**Arguments**

message (optional String)
:   The message which will be raised if the validation fails.

**Validate Greater Than**

Ensure that the value provided to this field is greater than a
provided value. This will create an active record validation,
a database constraint and will be used in API validation and
generated documentation.

```ruby
class MyModel < PlatformModel
  double_field :name do
    ...
    validate_greater_than :name, array: array
    ...
  end
end

```

**Arguments**

value (required Float)
:   The value to validate against. The provided value must be greater than this value

deferrable (optional Boolean)
:   The enforcement of constraints occurs by default at the end of each SQL statement. Setting `deferrable: true` allows you to customize this behaviour and optionally enforce the unique constraint at the end of a transaction instead of after each statement.

initially\_deferred (optional Boolean)
:   If true, then the default time to check the constraint will be at the end of the transaction rather than at the end of each statement.  Setting `initially\_deferred: true` requires that this constraint is also marked as `deferrable: true`.

message (optional String)
:   The message which will be displayed if the validation fails.

comment (optional String)
:   A comment which explains the reason for this validation on this field. This will be used to generate documentation, and will be added as a comment to the database constraint.

**Validate Greater Than Or Equal To**

Ensure that the value provided to this field is greater than
or equal to a provided value. This will create an active record
validation, a database constraint and will be used in API
validation and generated documentation.

```ruby
class MyModel < PlatformModel
  double_field :name do
    ...
    validate_greater_than_or_equal_to :name, array: array
    ...
  end
end

```

**Arguments**

value (required Float)
:   The value to validate against. The provided value must be greater than or equal to this value

deferrable (optional Boolean)
:   The enforcement of constraints occurs by default at the end of each SQL statement. Setting `deferrable: true` allows you to customize this behaviour and optionally enforce the unique constraint at the end of a transaction instead of after each statement.

initially\_deferred (optional Boolean)
:   If true, then the default time to check the constraint will be at the end of the transaction rather than at the end of each statement.  Setting `initially\_deferred: true` requires that this constraint is also marked as `deferrable: true`.

message (optional String)
:   The message which will be displayed if the validation fails.

comment (optional String)
:   A comment which explains the reason for this validation on this field. This will be used to generate documentation, and will be added as a comment to the database constraint.

**Validate Less Than**

Ensure that the value provided to this field is less than a
provided value. This will create an active record validation,
a database constraint and will be used in API validation and
generated documentation.

```ruby
class MyModel < PlatformModel
  double_field :name do
    ...
    validate_less_than :name, array: array
    ...
  end
end

```

**Arguments**

value (required Float)
:   The value to validate against. The provided value must be less than this value

deferrable (optional Boolean)
:   The enforcement of constraints occurs by default at the end of each SQL statement. Setting `deferrable: true` allows you to customize this behaviour and optionally enforce the unique constraint at the end of a transaction instead of after each statement.

initially\_deferred (optional Boolean)
:   If true, then the default time to check the constraint will be at the end of the transaction rather than at the end of each statement.  Setting `initially\_deferred: true` requires that this constraint is also marked as `deferrable: true`.

message (optional String)
:   The message which will be displayed if the validation fails.

comment (optional String)
:   A comment which explains the reason for this validation on this field. This will be used to generate documentation, and will be added as a comment to the database constraint.

**Validate Less Than Or Equal To**

Ensure that the value provided to this field is less than
or equal to a provided value. This will create an active record
validation, a database constraint and will be used in API
validation and generated documentation.

```ruby
class MyModel < PlatformModel
  double_field :name do
    ...
    validate_less_than_or_equal_to :name, array: array
    ...
  end
end

```

**Arguments**

value (required Float)
:   The value to validate against. The provided value must be less than or equal to this value

deferrable (optional Boolean)
:   The enforcement of constraints occurs by default at the end of each SQL statement. Setting `deferrable: true` allows you to customize this behaviour and optionally enforce the unique constraint at the end of a transaction instead of after each statement.

initially\_deferred (optional Boolean)
:   If true, then the default time to check the constraint will be at the end of the transaction rather than at the end of each statement.  Setting `initially\_deferred: true` requires that this constraint is also marked as `deferrable: true`.

message (optional String)
:   The message which will be displayed if the validation fails.

comment (optional String)
:   A comment which explains the reason for this validation on this field. This will be used to generate documentation, and will be added as a comment to the database constraint.

**Validate Equal To**

Ensure that the value provided to this field is equal to a
provided value. This will create an active record validation,
a database constraint and will be used in API validation and
generated documentation.

```ruby
class MyModel < PlatformModel
  double_field :name do
    ...
    validate_equal_to :name, array: array
    ...
  end
end

```

**Arguments**

value (required Float)
:   The value to validate against. The provided value must be equal to this value

deferrable (optional Boolean)
:   The enforcement of constraints occurs by default at the end of each SQL statement. Setting `deferrable: true` allows you to customize this behaviour and optionally enforce the unique constraint at the end of a transaction instead of after each statement.

initially\_deferred (optional Boolean)
:   If true, then the default time to check the constraint will be at the end of the transaction rather than at the end of each statement.  Setting `initially\_deferred: true` requires that this constraint is also marked as `deferrable: true`.

message (optional String)
:   The message which will be displayed if the validation fails.

comment (optional String)
:   A comment which explains the reason for this validation on this field. This will be used to generate documentation, and will be added as a comment to the database constraint.

**Validate In**

Ensure that the value provided to this field is equal to one of
the provided values. This will create an active record validation,
a database constraint and will be used in API validation and
generated documentation.

```ruby
class MyModel < PlatformModel
  double_field :name do
    ...
    validate_in :name, array: array
    ...
  end
end

```

**Arguments**

value (required [Float])
:   The value or array of values to validate against. The provided value must be equal to one of these values.

deferrable (optional Boolean)
:   The enforcement of constraints occurs by default at the end of each SQL statement. Setting `deferrable: true` allows you to customize this behaviour and optionally enforce the unique constraint at the end of a transaction instead of after each statement.

initially\_deferred (optional Boolean)
:   If true, then the default time to check the constraint will be at the end of the transaction rather than at the end of each statement.  Setting `initially\_deferred: true` requires that this constraint is also marked as `deferrable: true`.

message (optional String)
:   The message which will be displayed if the validation fails.

comment (optional String)
:   A comment which explains the reason for this validation on this field. This will be used to generate documentation, and will be added as a comment to the database constraint.

**Validate Not In**

Ensure that the value provided to this field is not equal to one of
the provided values. This will create an active record validation,
a database constraint and will be used in API validation and
generated documentation.

```ruby
class MyModel < PlatformModel
  double_field :name do
    ...
    validate_not_in :name, array: array
    ...
  end
end

```

**Arguments**

value (required [Float])
:   The value or array of values to validate against. The provided value must not be equal to any of these values.

deferrable (optional Boolean)
:   The enforcement of constraints occurs by default at the end of each SQL statement. Setting `deferrable: true` allows you to customize this behaviour and optionally enforce the unique constraint at the end of a transaction instead of after each statement.

initially\_deferred (optional Boolean)
:   If true, then the default time to check the constraint will be at the end of the transaction rather than at the end of each statement.  Setting `initially\_deferred: true` requires that this constraint is also marked as `deferrable: true`.

message (optional String)
:   The message which will be displayed if the validation fails.

comment (optional String)
:   A comment which explains the reason for this validation on this field. This will be used to generate documentation, and will be added as a comment to the database constraint.

**Zero To Null**

Ensures that the value of this field can not be the number 0.
If it is the number 0, then it will be converted automatically
to null. This coercion logic will be installed into active record,
and a constraint will be added to the database to ensure there are
no 0 values. If used on an array field, then vaues of 0 will be
automatically removed from the array and the database constraint will
forbid any arrays with a value of 0.

```ruby
class MyModel < PlatformModel
  double_field :name do
    ...
    zero_to_null :name, array: array
    ...
  end
end

```

**Arguments**

comment (optional String)
:   A comment which explains the reason for converting 0 to null on this field. This will be used to generate documentation, and will be added as a comment to the database constraint.

**Remove Null Array Values**

Ensures that the value of this field does not contain any null values.
Any null values will automatically be removed before saving the record.
This coercion logic will be installed into active record. A validation
will also be added to the database to assert that the column has no
null values. This is only compatibile with array fields.

```ruby
class MyModel < PlatformModel
  double_field :name do
    ...
    remove_null_array_values :name, array: array
    ...
  end
end

```

**Arguments**

comment (optional String)
:   A comment which explains the reason for automatically removing any null values from this field. This will be used to generate documentation, and will be added as a comment to the database constraint.