---
layout: default
title: Description
parent: Mutators
has_children: false
has_toc: false
permalink: /mutators/description
---

Add descriptions to your classes.

```ruby
class MyMutation < PlatformerMutation
  description description
end
```

**Arguments**

| Name | Required | Type | Description |
|:---|:---|:---|:---|
| description | required | String | The description to add. This accepts markdown. |