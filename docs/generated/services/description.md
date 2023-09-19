---
layout: default
title: Description
parent: Services
has_children: false
has_toc: false
permalink: /services/description
---

Add descriptions to your classes.

```ruby
class MyService < PlatformerService
  description description
end
```

**Arguments**

| Name | Required | Type | Description |
|:---|:---|:---|:---|
| description | required | String | The description to add. This accepts markdown. |