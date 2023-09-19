---
layout: default
title: Fields
parent: Schemas
has_children: false
has_toc: false
permalink: /schemas/fields
---

# Fields
{: .no_toc }

A list of the all this models scalar and enum fields which will be exposed via graphql.

```ruby
class MySchema < PlatformSchema
  fields [:value]
end
```

#### Fields Arguments
{: .no_toc }

| Name | Required | Type | Description |
|:---|:---|:---|:---|
| fields | required | Array[Symbol] | The names of this models fields to expose. |