---
layout: default
title: Description
parent: Callbacks
has_children: false
has_toc: false
permalink: /callbacks/description
---

# Description
{: .no_toc }

Add descriptions to your classes.

```ruby
class MyCallback < PlatformCallback
  description "description"
end
```

#### Description Arguments
{: .no_toc }

| Name | Required | Type | Description |
|:---|:---|:---|:---|
| description | required | String | The description to add. This accepts markdown. |