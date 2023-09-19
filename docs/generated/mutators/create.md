---
layout: default
title: Create
parent: Mutators
has_children: false
has_toc: false
permalink: /mutators/create
---

Adds a mutation to create a new record of this model.

```ruby
class MyMutation < PlatformerMutation
  create 
end
```

**Additional Configuration Options**

**Fields**

A list of this models fields which can be set via this create mutation.

```ruby
class MyMutation < PlatformMutation
  create  do
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