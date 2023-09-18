---
layout: default
title: Primary Key
parent: Models
has_children: false
---

Add a primary key to this table.

```ruby
class My::BaseModel < Platformer::BaseModel
  primary_key 
end

```

**Arguments**

column\_names (optional [Symbol])
:   If provided, then these existing columns will be used to build the primary key. If ommited, then a default column named `id` with a datatype of `uuid` will be added automatically and used for the primary key.

**Additional Configuration Options**

**Comment**

This method is used to describe a specific use of this
field within a model, this description will be added to
the database column as a comment, and will be used to
generate API documentation.

```ruby
class My::BaseModel < Platform::BaseModel
  primary_key  do
    ...
    comment column_names: [:column_names]
    ...
  end
end

```

**Arguments**

comment (required String)
:   The description of this field