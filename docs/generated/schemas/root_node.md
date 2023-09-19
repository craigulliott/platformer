---
layout: default
title: Root Node
parent: Schemas
has_children: false
has_toc: false
permalink: /schemas/root_node
---

# Root Node
{: .no_toc }

Makes this model available via a root node query.

```ruby
class MySchema < PlatformSchema
  root_node 
end
```

## Additional Configuration
{: .no_toc }

You can further configure the Root Node by using the following methods:

### By

Provides an argument and installs functionality
to allow this model to be queried by it's ID.

```ruby
class MySchema < PlatformSchema
  root_node  do
    ...
    by_id 
    ...
  end
end
```

### By Exact String

Allows for a string search against one of the models fields.

```ruby
class MySchema < PlatformSchema
  root_node  do
    ...
    # required arguments only
    by_exact_string :value
    # all possible arguments
    by_exact_string :value, required: false
    ...
  end
end
```

#### By Exact String Arguments
{: .no_toc }

| Name | Required | Type | Description |
|:---|:---|:---|:---|
| field_name | required | Symbol | The name of the field we are searching against. |
| required | optional | Boolean | If true. then using this argument is required when querying this collection. |