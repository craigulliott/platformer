---
layout: default
title: Core Timestamps
parent: Models
has_children: false
has_toc: false
permalink: /models/core_timestamps
---

Add the automatically managed `updated_at` and `created_at` timestamps
to this model. By default, both will be added.

```ruby
class MyModel < PlatformerModel
  core_timestamps 
end
```

**Arguments**

| Name | Required | Type | Description |
|:---|:---|:---|:---|
| created_at | optional | Boolean | Set to false to ommit the created_at timestamp |
| updated_at | optional | Boolean | Set to false to ommit the updated_at timestamp |