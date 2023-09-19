---
layout: default
title: Update
parent: Mutators
has_children: false
has_toc: false
permalink: /mutators/update
---

Adds a mutation to update a new record of this model.

```ruby
class MyMutation < PlatformerMutation
  update 
end
```

**Additional Configuration Options**

**Fields**

A list of this models fields which can be set via this update mutation.

```ruby
class MyMutation < PlatformMutation
  update  do
    ...
    fields 
    ...
  end
end
```

**Arguments**

| Name | Required | Type | Description |
|:---|:---|:---|:---|
| fields | required | Array[Symbol] | The list of field names. |