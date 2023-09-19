---
layout: default
title: Description
parent: Schemas
has_children: false
has_toc: false
permalink: /schemas/description
---

# Description
{: .no_toc }

Add descriptions to your classes.

```ruby
class MySchema < PlatformSchema
  description "description"
end
```

#### Description Arguments
{: .no_toc }

| Name | Required | Type | Description |
|:---|:---|:---|:---|
| description | required | String | The description to add. This accepts markdown. |