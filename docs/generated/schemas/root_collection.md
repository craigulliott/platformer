---
layout: default
title: Root Collection
parent: Schemas
has_children: false
has_toc: false
permalink: /schemas/root_collection
---

# Root Collection
{: .no_toc }

Makes a collection of these models available via a root query.

```ruby
class MySchema < PlatformSchema
  root_collection 
end
```

## Additional Configuration
{: .no_toc }

You can further configure the Root Collection by using the following methods:

### By Exact String

Allows for a string search against one of the models fields.

```ruby
class MySchema < PlatformSchema
  root_collection  do
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