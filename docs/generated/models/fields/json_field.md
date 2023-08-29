Add a json field to this model.

```ruby
class MyModel < PlatformModel
  json_field :name
end

```

**Arguments**

name (required Symbol)
:   The name of your field.

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

comment (optional String)
:   A comment which explains the reason for adding coercing empty arrays to null on this field. This will be used to generate documentation, and will be added as a comment to the database constraint.

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

default (required String)
:   

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

comment (required String)
:   The description of this field

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
  json_field :name do
    ...
    immutable_once_set :name
    ...
  end
end

```

**Arguments**

message (optional String)
:   The message which will be raised if the validation fails.