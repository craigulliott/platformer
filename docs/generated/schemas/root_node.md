Makes this model available via a root node query.

```ruby
class Myer::BaseSchema < Platformer::BaseSchema
  root_node 
end

```

**Additional Configuration Options**

**By**

Provides an argument and installs functionality
to allow this model to be queried by it's ID.

```ruby
class Myer::BaseSchema < Platformer::BaseSchema
  root_node  do
    ...
    by_id 
    ...
  end
end

```

**By Exact String**

Allows for a string search against one of the models fields.

```ruby
class Myer::BaseSchema < Platformer::BaseSchema
  root_node  do
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