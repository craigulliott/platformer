# GraphQL schema and base types
#
# the base classes which all other types extend from
require_relative "types/base_argument"
require_relative "types/base_field"
require_relative "types/base_object"
require_relative "types/base_connection"
require_relative "types/base_edge"
require_relative "types/base_enum"
require_relative "types/base_input_object"
require_relative "types/base_interface"
require_relative "types/base_scalar"
require_relative "types/base_union"
# the node type is a special type which is qequired for a
# standards compliant server, it uses global ids for fetching
# any available object
require_relative "types/node_type"
# base classes for mutations and subscriptions
require_relative "mutations/base_mutation"
require_relative "subscriptions/base_subscription"
# the base schema and root types, the main business logic is
# contained within these classes, so that we can easily recreate
# the server from within our specs..
require_relative "schema_base/queries_base"
require_relative "schema_base/mutations_base"
require_relative "schema_base/subscriptions_base"
require_relative "schema_base"
# the schema and root types
require_relative "schema/queries"
require_relative "schema/mutations"
require_relative "schema/subscriptions"
require_relative "schema"
