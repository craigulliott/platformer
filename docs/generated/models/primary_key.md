---
layout: default
title: Primary Key
parent: Models
has_children: false
has_toc: false
permalink: /models/primary_key
---

# Primary Key
{: .no_toc }

Add a primary key to this table.

```ruby
class MyModel < PlatformModel
  # required arguments only
  primary_key 
  # all possible arguments
  primary_key column_names: [:value]
end
```

#### Primary Key Arguments
{: .no_toc }

| Name | Required | Type | Description |
|:---|:---|:---|:---|
| column_names | optional | Array[Symbol] | If provided, then these existing columns will be used to build the primary key. If ommited, then a default column named `id` with a datatype of `uuid` will be added automatically and used for the primary key. |

## Additional Configuration
{: .no_toc }

You can further configure the Primary Key by using the following methods:

### Comment

This method is used to describe a specific use of this
field within a model, this description will be added to
the database column as a comment, and will be used to
generate API documentation.

```ruby
class MyModel < PlatformModel
  primary_key  do
    ...
    comment "comment"
    ...
  end
end
```

#### Comment Arguments
{: .no_toc }

| Name | Required | Type | Description |
|:---|:---|:---|:---|
| comment | required | String | The description of this field |