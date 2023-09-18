---
layout: default
title: Root Collection
parent: Schemas
has_children: false
---

Makes a collection of these models available via a root query.

```ruby
class MySchema < PlatformerSchema
  root_collection 
end

```

**Additional Configuration Options**

**By Exact String**

Allows for a string search against one of the models fields.

```ruby
class MySchema < PlatformSchema
  root_collection  do
    ...
    by_exact_string 
    ...
  end
end

```

**Arguments**

field\_name (required Symbol)
:   The name of the field we are searching against.

required (optional Boolean)
:   If true. then using this argument is required when querying this collection.