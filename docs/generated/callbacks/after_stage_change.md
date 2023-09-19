---
layout: default
title: After Stage Change
parent: Callbacks
has_children: false
has_toc: false
permalink: /callbacks/after_stage_change
---

# After Stage Change
{: .no_toc }

```ruby
class MyCallback < PlatformCallback
  # required arguments only
  after_stage_change :value
  # all possible arguments
  after_stage_change :value, from: :value
end
```

#### After Stage Change Arguments
{: .no_toc }

| Name | Required | Type | Description |
|:---|:---|:---|:---|
| to | required | Symbol |  |
| from | optional | Symbol |  |