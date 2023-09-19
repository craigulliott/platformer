---
layout: default
title: Fields
parent: Schemas
has_children: false
has_toc: false
permalink: /schemas/fields
---

A list of the all this models scalar and enum fields which will be exposed via graphql.

```ruby
class MySchema < PlatformerSchema
  fields :fields
end
```

**Arguments**

| Name | Required | Type | Description |
|:---|:---|:---|:---|
| fields | required | Array[Symbol] | The names of this models fields to expose. |