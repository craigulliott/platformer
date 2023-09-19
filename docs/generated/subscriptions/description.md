---
layout: default
title: Description
parent: Subscriptions
has_children: false
has_toc: false
permalink: /subscriptions/description
---

# Description
{: .no_toc }

Add descriptions to your classes.

```ruby
class MySubscription < PlatformSubscription
  description "description"
end
```

#### Description Arguments
{: .no_toc }

| Name | Required | Type | Description |
|:---|:---|:---|:---|
| description | required | String | The description to add. This accepts markdown. |