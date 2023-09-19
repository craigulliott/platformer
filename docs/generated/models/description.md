---
layout: default
title: Description
parent: Models
has_children: false
has_toc: false
permalink: /models/description
---

# Description
{: .no_toc }

Add descriptions to your classes.

```ruby
class MyModel < PlatformModel
  description "description"
end
```

#### Description Arguments
{: .no_toc }

| Name | Required | Type | Description |
|:---|:---|:---|:---|
| description | required | String | The description to add. This accepts markdown. |