Add a field to this model for storing IPv4 and IPv6 hosts and networks.

```ruby
class Myer::BaseModel < Platformer::BaseModel
  mac_address_field :name
end

```

**Arguments**

name (required Symbol)
:   The name of your field.

array (optional Boolean)
:   If true, then this field will be an array of macaddrs, and will be backed by a `macaddr[]` type in PostgreSQL.

**Additional Configuration Options**

**Default**

```ruby
class Myer::BaseModel < Platformer::BaseModel
  mac_address_field :name do
    ...
    default :name, array: array
    ...
  end
end

```

**Arguments**

default (required String)
:   

**Allow Null**

If true, then a null value is permitted for this field. This
is validated at the API level and with active record validations.
The underlying postgres column will also be configured to allow
NULL values

```ruby
class Myer::BaseModel < Platformer::BaseModel
  mac_address_field :name do
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
class Myer::BaseModel < Platformer::BaseModel
  mac_address_field :name do
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
class Myer::BaseModel < Platformer::BaseModel
  mac_address_field :name do
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
class Myer::BaseModel < Platformer::BaseModel
  mac_address_field :name do
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
class Myer::BaseModel < Platformer::BaseModel
  mac_address_field :name do
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
class Myer::BaseModel < Platformer::BaseModel
  mac_address_field :name do
    ...
    immutable_once_set :name, array: array
    ...
  end
end

```

**Arguments**

message (optional String)
:   The message which will be raised if the validation fails.

**Remove Null Array Values**

Ensures that the value of this field does not contain any null values.
Any null values will automatically be removed before saving the record.
This coercion logic will be installed into active record. A validation
will also be added to the database to assert that the column has no
null values. This is only compatibile with array fields.

```ruby
class Myer::BaseModel < Platformer::BaseModel
  mac_address_field :name do
    ...
    remove_null_array_values :name, array: array
    ...
  end
end

```

**Arguments**

comment (optional String)
:   A comment which explains the reason for automatically removing any null values from this field. This will be used to generate documentation, and will be added as a comment to the database constraint.