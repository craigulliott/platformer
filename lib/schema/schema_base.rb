# A GraphQL system is called a schema. The schema contains all the types
# and fields in the system. The schema executes queries and publishes an
# introspection system.
class SchemaBase < GraphQL::Schema
  include Platformer::Logger

  # Root types (query, mutation, and subscription) are the entry points
  # for queries to the system. We dynamically compose the schema by calling
  # the `field` method on each of these root these methods to add queries,
  # mutations and subscriptions based on how the system has been configured
  # via our DSL.
  #
  # This is wrapped in a singleton method so we can easily recreate the server
  # from within our specs and initialize it with the new fields.
  def self.initialize!
    if Schema::Queries.fields.reject { |name, field| name == "node" || name == "nodes" }.any?
      query(Schema::Queries)
    else
      log.warn "No queries defined, skipping GraphQL query root type."
    end

    if Schema::Mutations.fields.any?
      mutation(Schema::Mutations)
    else
      log.warn "No mutations defined, skipping GraphQL migration root type."
    end

    if Schema::Subscriptions.fields.any?
      subscription(Schema::Subscriptions)
    else
      log.warn "No subscriptions defined, skipping GraphQL subscription root type."
    end
  end

  # For batch-loading (see https://graphql-ruby.org/dataloader/overview.html)
  use GraphQL::Dataloader

  # Pagination
  default_max_page_size 100
  default_page_size 20

  # GraphQL-Ruby calls this when something goes wrong while running a query:
  def self.type_error(err, context)
    # if err.is_a?(GraphQL::InvalidNullError)
    #   # report to your bug tracker here
    #   return nil
    # end
    super
  end

  # Union and Interface Resolution, this tells the schema
  # what type Relay `Node` objects are
  def self.resolve_type(abstract_type, obj, ctx)
    abstract_type
  end

  # Stop validating when it encounters this many errors:
  validate_max_errors(100)

  # Relay-style Object Identification:

  # Return a string UUID for `object`
  def self.id_from_object(object, type_definition, query_ctx)
    # For example, use Rails' GlobalID library (https://github.com/rails/globalid):
    object.to_gid_param
  end

  # Given a string UUID, find the object
  def self.object_from_id(global_id, query_ctx)
    # For example, use Rails' GlobalID library (https://github.com/rails/globalid):
    GlobalID.find(global_id)
  end
end
