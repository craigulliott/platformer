---
layout: default
title: Action
parent: Mutators
has_children: false
has_toc: false
permalink: /mutators/action
---

# Action
{: .no_toc }

Adds a mutation based on one of this models action fields.

```ruby
class MyMutation < PlatformMutation
  action :value
end
```

#### Action Arguments
{: .no_toc }

| Name | Required | Type | Description |
|:---|:---|:---|:---|
| action_field_name | required | Symbol | The name of the action field which this action is for |

## Additional Configuration
{: .no_toc }

You can further configure the Action by using the following methods:

### Fields

A list of this models fields which can be changed via this mutation.

```ruby
class MyMutation < PlatformMutation
  action :value do
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