module Types
  class BaseEdge < Types::BaseObject
    # add `node` and `cursor` fields, as well as `node_type(...)` override
    include GraphQL::Types::Relay::EdgeBehaviors
  end
end

# called here, because there is a circular dependency between these classes
Types::BaseObject.edge_type_class(Types::BaseEdge)
