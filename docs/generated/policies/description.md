---
layout: default
title: Description
parent: Policies
has_children: false
has_toc: false
permalink: /policies/description
---

Add descriptions to your classes.

```ruby
class MyPolicy < PlatformerPolicy
  description description
end
```

**Arguments**

| Name | Required | Type | Description |
|:---|:---|:---|:---|
| description | required | String | The description to add. This accepts markdown. |