---
layout: default
title: Action
parent: Mutators
has_children: false
has_toc: false
permalink: /mutators/action
---

Adds a mutation based on one of this models action fields.

```ruby
class MyMutation < PlatformerMutation
  action :action_field_name
end
```

**Arguments**

| Name | Required | Type | Description |
|:---|:---|:---|:---|
| action_field_name | required | Symbol | The name of the action field which this action is for |

**Additional Configuration Options**

**Fields**

A list of this models fields which can be changed via this mutation.

```ruby
class MyMutation < PlatformMutation
  action :action_field_name do
    ...
    fields :action_field_name
    ...
  end
end
```

**Arguments**

| Name | Required | Type | Description |
|:---|:---|:---|:---|
| fields | required | Array[Symbol] | The list of field names. |