---
layout: default
title: Connection
parent: Schemas
has_children: false
has_toc: false
permalink: /schemas/connection
---

In GraphQL, a "connection" serves as a specialized abstraction layer
that facilitates the relationship between a node and a list of other
nodes. Unlike a simple list, a connection wraps this relationship in
a dedicated object, providing a namespace specifically designed for
additional metadata. This design allows for more advanced features
like pagination, sorting, and filtering. Essentially, a connection
not only reveals the interconnected nodes but also offers room for
enhanced functionality and information about the relationship itself.
This makes it a more flexible and extensible choice for managing lists
and relationships within a GraphQL schema.

```ruby
class MySchema < PlatformerSchema
  connection "Foreign Model"
end
```

**Arguments**

| Name | Required | Type | Description |
|:---|:---|:---|:---|
| foreign_model | required | Class | The model which is associated to this model via the `has_many` association. |
| association_name | optional | Symbol | If a custom name was used when creating the association between this model and the foreign model, then this name should be provided here. |

**Additional Configuration Options**

**Edge**

When a has_many association between a model and its foreign models
employs a join table—specified by the through: option—you can use this
method to surface additional data from the intermediary model. For
instance, if a user is connected to multiple organizations via a
'Membership' model that contains a 'scope' attribute (representing, for
example, the user's permission level within the organization), this
method enables you to expose both the connection between users and
organizations, as well as this critical piece of metadata within the
GraphQL query. This approach enriches the data available, offering a
more comprehensive and nuanced view of the relationship between entities.

```ruby
class MySchema < PlatformSchema
  connection "Foreign Model" do
    ...
    edge "Foreign Model", association_name: :association_name
    ...
  end
end
```

**Arguments**

| Name | Required | Type | Description |
|:---|:---|:---|:---|
| field_name | required | Symbol | The name of the field on the join model to expose via an edge. |