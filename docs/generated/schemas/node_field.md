Adds a new node directly to the current node's list of fields. This
approach is recommended for singular associations between models, as
established through `belongs_to` or `has_one` methods in the model's
definition. It's particularly useful when the association doesn't
require, and is unlikely to require, any associated metadata in the
future. If the association to the other model uses a join table, or
there is any possibility that you may need to expose relationship metadata
later on, then you should use a join model, and then provide access
to the other model through that join model.

```ruby
class MySchema < PlatformSchema
  node_field "Foreign Model"
end

```

**Arguments**

foreign\_model (required Class)
:   The model which is associated to this model via the `has\_one` or `belongs\_to` association.

association\_name (optional Symbol)
:   If a custom name was used when creating the association between this model and the foreign model, then this name should be provided here.