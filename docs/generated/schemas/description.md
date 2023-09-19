---
layout: default
title: Description
parent: Schemas
has_children: false
has_toc: false
permalink: /schemas/description
---

Add descriptions to your classes.

```ruby
class MySchema < PlatformerSchema
  description description
end
```

**Arguments**

| Name | Required | Type | Description |
|:---|:---|:---|:---|
| description | required | String | The description to add. This accepts markdown. |