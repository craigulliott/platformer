---
layout: default
title: Create
parent: Mutators
has_children: false
has_toc: false
permalink: /mutators/create
---

# Create
{: .no_toc }

Adds a mutation to create a new record of this model.

```ruby
class MyMutation < PlatformMutation
  create 
end
```

## Additional Configuration
{: .no_toc }

You can further configure the Create by using the following methods:

### Fields

A list of this models fields which can be set via this create mutation.

```ruby
class MyMutation < PlatformMutation
  create  do
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