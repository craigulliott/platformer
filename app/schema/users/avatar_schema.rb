module Users
  # represents a node in our graph, a node is basically an object in our schema
  class Avatar < PlatformSchema
    # for records like avatars and categories which are used commonly
    # and are not numerous
    cache_locally timeout: 1.hour

    # for records like avatars and categories which are used commonly
    # and are not numerous
    cache_remotely timeout: 1.hour

    # the list of fields (data) which is directly available on this node
    fields [
      :url
    ]
  end
end
