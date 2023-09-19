---
layout: default
title: State Machine Action
parent: Mutators
has_children: false
has_toc: false
permalink: /mutators/state_machine_action
---

Adds a mutation which coresponds to an action in a state machine for this model.

```ruby
class MyMutation < PlatformerMutation
  state_machine_action :action_name
end
```

**Arguments**

| Name | Required | Type | Description |
|:---|:---|:---|:---|
| action_name | required | Symbol | The name of an action within this models state machine. |
| state_machine | optional | Symbol | If the state machine was given a custom name, then provide the name here. |

**Additional Configuration Options**

**Fields**

A list of this models fields which can be changed via this mutation.

```ruby
class MyMutation < PlatformMutation
  state_machine_action :action_name do
    ...
    fields :action_name, state_machine: :state_machine
    ...
  end
end
```

**Arguments**

| Name | Required | Type | Description |
|:---|:---|:---|:---|
| fields | required | Array[Symbol] | The list of field names. |