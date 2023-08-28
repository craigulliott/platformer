module Users
  # represents a node in our graph, a node is basically an object in our schema

  # there should be a 1:1 mapping between models and schema files (unless the model is internal)
  class UserSchema < PlatformSchema
    # make available as a root node
    root_node do
      by_id
    end

    # dont call the model users_user
    suppress_namespace

    # the list of leaves fields (data) which is directly available on this node, this consists of
    # your scalar and enum types
    fields [
      :name,
      :email,
      :phone_number_formatted,
      :type
    ]

    # a has one or belongs to relationship, where its a single model and there is no
    # additional metadata/join model
    node_field :avatar do
      # where this is a single model, and there will never be any additional metadata
    end

    # connections are a type of generic which represents a relationship between nodes, and
    # returns metadata for things like pagination along with any nodes at the end of this
    # connection
    connection :organizations do
      # edges should be added automatically if there is a join table (through:), and can optionally be added
      # if there is potential there might be a need to expose relationship meta data in the future
      edge :group # this is a node (represents a join model off the memberships table)
      edge :joined_at
      edge :type # studentship, membership, instructorship, ownership etc.
    end
  end
end
