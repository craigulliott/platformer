A list of the all this models scalar and enum fields which will be exposed via graphql.

```ruby
class MySchema < PlatformSchema
  fields :fields
end

```

**Arguments**

fields (required [Symbol])
:   The names of this models fields to expose.