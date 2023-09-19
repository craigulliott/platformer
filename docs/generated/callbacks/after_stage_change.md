---
layout: default
title: After Stage Change
parent: Callbacks
has_children: false
has_toc: false
permalink: /callbacks/after_stage_change
---

```ruby
class MyCallback < PlatformerCallback
  after_stage_change :to
end
```

**Arguments**

| Name | Required | Type | Description |
|:---|:---|:---|:---|
| to | required | Symbol |  |
| from | optional | Symbol |  |