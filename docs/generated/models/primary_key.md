---
layout: default
title: Primary Key
parent: Models
has_children: false
has_toc: false
permalink: /models/primary_key
---

Add a primary key to this table.

```ruby
class MyModel < PlatformerModel
  primary_key 
end
```

**Arguments**

| Name | Required | Type | Description |
|:---|:---|:---|:---|
| column_names | optional | Array[Symbol] | If provided, then these existing columns will be used to build the primary key. If ommited, then a default column named `id` with a datatype of `uuid` will be added automatically and used for the primary key. |

**Additional Configuration Options**

**Comment**

This method is used to describe a specific use of this
field within a model, this description will be added to
the database column as a comment, and will be used to
generate API documentation.

```ruby
class MyModel < PlatformModel
  primary_key  do
    ...
    comment column_names: [:column_names]
    ...
  end
end
```

**Arguments**

| Name | Required | Type | Description |
|:---|:---|:---|:---|
| comment | required | String | The description of this field |