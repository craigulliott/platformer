---
layout: default
title: Description
parent: Presenters
has_children: false
has_toc: false
permalink: /presenters/description
---

# Description
{: .no_toc }

Add descriptions to your classes.

```ruby
class MyPresenter < PlatformPresenter
  description "description"
end
```

#### Description Arguments
{: .no_toc }

| Name | Required | Type | Description |
|:---|:---|:---|:---|
| description | required | String | The description to add. This accepts markdown. |