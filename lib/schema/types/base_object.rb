module Types
  class BaseObject < GraphQL::Schema::Object
    # `edge_type_class` is called from within `./base_edge.rb` because
    # there is a circular dependency between the two classes
    # `edge_type_class(Types::BaseEdge)`

    # `connection_type_class` is called from within `./base_connection.rb` because
    # there is a circular dependency between the two classes
    # `connection_type_class(Types::BaseConnection)`

    field_class Types::BaseField
  end
end
