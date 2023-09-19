---
layout: default
title: Description
parent: Presenters
has_children: false
has_toc: false
permalink: /presenters/description
---

Add descriptions to your classes.

```ruby
class MyPresenter < PlatformerPresenter
  description description
end
```

**Arguments**

| Name | Required | Type | Description |
|:---|:---|:---|:---|
| description | required | String | The description to add. This accepts markdown. |