---
layout: default
title: Description
parent: Callbacks
has_children: false
has_toc: false
permalink: /callbacks/description
---

Add descriptions to your classes.

```ruby
class MyCallback < PlatformerCallback
  description description
end
```

**Arguments**

| Name | Required | Type | Description |
|:---|:---|:---|:---|
| description | required | String | The description to add. This accepts markdown. |