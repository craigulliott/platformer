---
layout: default
title: Description
parent: Subscriptions
has_children: false
has_toc: false
permalink: /subscriptions/description
---

Add descriptions to your classes.

```ruby
class MySubscription < PlatformerSubscription
  description description
end
```

**Arguments**

| Name | Required | Type | Description |
|:---|:---|:---|:---|
| description | required | String | The description to add. This accepts markdown. |