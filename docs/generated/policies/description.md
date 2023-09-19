---
layout: default
title: Description
parent: Policies
has_children: false
has_toc: false
permalink: /policies/description
---

# Description
{: .no_toc }

Add descriptions to your classes.

```ruby
class MyPolicy < PlatformPolicy
  description "description"
end
```

#### Description Arguments
{: .no_toc }

| Name | Required | Type | Description |
|:---|:---|:---|:---|
| description | required | String | The description to add. This accepts markdown. |