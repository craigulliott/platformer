---
layout: default
title: Description
parent: Mutators
has_children: false
has_toc: false
permalink: /mutators/description
---

# Description
{: .no_toc }

Add descriptions to your classes.

```ruby
class MyMutation < PlatformMutation
  description "description"
end
```

#### Description Arguments
{: .no_toc }

| Name | Required | Type | Description |
|:---|:---|:---|:---|
| description | required | String | The description to add. This accepts markdown. |