---
layout: default
title: Core Timestamps
parent: Models
has_children: false
---

Add the automatically managed `updated_at` and `created_at` timestamps
to this model. By default, both will be added.

```ruby
class My::BaseModel < Platformer::BaseModel
  core_timestamps 
end

```

**Arguments**

created\_at (optional Boolean)
:   Set to false to ommit the created\_at timestamp

updated\_at (optional Boolean)
:   Set to false to ommit the updated\_at timestamp