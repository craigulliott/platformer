---
layout: default
title: Update
parent: Mutators
has_children: false
has_toc: false
permalink: /mutators/update
---

# Update
{: .no_toc }

Adds a mutation to update a new record of this model.

```ruby
class MyMutation < PlatformMutation
  update 
end
```

## Additional Configuration
{: .no_toc }

You can further configure the Update by using the following methods:

### Fields

A list of this models fields which can be set via this update mutation.

```ruby
class MyMutation < PlatformMutation
  update  do
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