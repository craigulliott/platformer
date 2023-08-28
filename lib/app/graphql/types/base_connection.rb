module Types
  class BaseConnection < Types::BaseObject
    # add `nodes` and `pageInfo` fields, as well as `edge_type(...)` and `node_nullable(...)` overrides
    include GraphQL::Types::Relay::ConnectionBehaviors
  end
end

# called here, because there is a circular dependency between these classes
Types::BaseObject.connection_type_class(Types::BaseConnection)
