---
layout: default
title: Description
parent: Models
has_children: false
has_toc: false
permalink: /models/description
---

Add descriptions to your classes.

```ruby
class MyModel < PlatformerModel
  description description
end
```

**Arguments**

| Name | Required | Type | Description |
|:---|:---|:---|:---|
| description | required | String | The description to add. This accepts markdown. |