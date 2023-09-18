---
layout: default
title: Positionable
parent: Models
has_children: false
---

Adds functionality to your model which allows manual sorting of records.

A required integer column named 'position' will be added to your model, and
constraints and stored procedures will be used to ensure ensures that the
`position` values remain consistent and sequentially ordered, starting from the
number 1.

```ruby
class MyModel < PlatformerModel
  positionable 
end

```

**Arguments**

scope (optional [Symbol])
:   The name of fields which this models unique position should be scoped to.

**Additional Configuration Options**

**Comment**

This method is used to describe a specific use of this
field within a model, this description will be added to
the database column as a comment, and will be used to
generate API documentation.

```ruby
class MyModel < PlatformModel
  positionable  do
    ...
    comment scope: [:scope]
    ...
  end
end

```

**Arguments**

comment (required String)
:   The description of this field