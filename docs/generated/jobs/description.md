---
layout: default
title: Description
parent: Jobs
has_children: false
has_toc: false
permalink: /jobs/description
---

Add descriptions to your classes.

```ruby
class MyJob < PlatformerJob
  description description
end
```

**Arguments**

| Name | Required | Type | Description |
|:---|:---|:---|:---|
| description | required | String | The description to add. This accepts markdown. |