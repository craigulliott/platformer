---
layout: default
title: Description
parent: Jobs
has_children: false
has_toc: false
permalink: /jobs/description
---

# Description
{: .no_toc }

Add descriptions to your classes.

```ruby
class MyJob < PlatformJob
  description "description"
end
```

#### Description Arguments
{: .no_toc }

| Name | Required | Type | Description |
|:---|:---|:---|:---|
| description | required | String | The description to add. This accepts markdown. |