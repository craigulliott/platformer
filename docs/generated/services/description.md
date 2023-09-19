---
layout: default
title: Description
parent: Services
has_children: false
has_toc: false
permalink: /services/description
---

# Description
{: .no_toc }

Add descriptions to your classes.

```ruby
class MyService < PlatformService
  description "description"
end
```

#### Description Arguments
{: .no_toc }

| Name | Required | Type | Description |
|:---|:---|:---|:---|
| description | required | String | The description to add. This accepts markdown. |