---
layout: default
title: State Machine Action
parent: Mutators
has_children: false
has_toc: false
permalink: /mutators/state_machine_action
---

# State Machine Action
{: .no_toc }

Adds a mutation which coresponds to an action in a state machine for this model.

```ruby
class MyMutation < PlatformMutation
  # required arguments only
  state_machine_action :value
  # all possible arguments
  state_machine_action :value, state_machine: :value
end
```

#### State Machine Action Arguments
{: .no_toc }

| Name | Required | Type | Description |
|:---|:---|:---|:---|
| action_name | required | Symbol | The name of an action within this models state machine. |
| state_machine | optional | Symbol | If the state machine was given a custom name, then provide the name here. |

## Additional Configuration
{: .no_toc }

You can further configure the State Machine Action by using the following methods:

### Fields

A list of this models fields which can be changed via this mutation.

```ruby
class MyMutation < PlatformMutation
  state_machine_action :value do
    ...
    fields [:value]
    ...
  end
end
```

#### Fields Arguments
{: .no_toc }

| Name | Required | Type | Description |
|:---|:---|:---|:---|
| fields | required | Array[Symbol] | The list of field names. |