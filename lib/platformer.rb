# frozen_string_literal: true

ENV["RACK_ENV"] ||= "development"

require "dsl_compose"
require "dynamic_migrations"

# for generating uuids
require "securerandom"

# iso country codes and names (also provides international dialing codes)
require "countries"

# language ISO codes
require "iso-639"

# currency codes, money related functions, formatting and currency conversion
require "money"

# orm (ActiveRecord)
require "active_record"

# graphql
require "graphql"

# convenience method to simplify the requires below
def recursive_require path
  Dir[File.expand_path path].each do |f|
    require_relative f
  end
end

require "platformer/version"

require "platformer/databases"
require "platformer/databases/postgres/server"
require "platformer/databases/postgres/server/database"
require "platformer/databases/configuration"
require "platformer/databases/migrations"
require "platformer/databases/migrations/migration_file"
require "platformer/databases/migrations/current"
require "platformer/databases/migrations/current/loader"

recursive_require "lib/active_record/**/*.rb"

# the base class which all active record models extend from
require "app/active_record/application_record"

# GraphQL
#
# the base classes which all other types extend from
require "app/graphql/types/base_argument"
require "app/graphql/types/base_field"
require "app/graphql/types/base_object"
require "app/graphql/types/base_connection"
require "app/graphql/types/base_edge"
require "app/graphql/types/base_enum"
require "app/graphql/types/base_input_object"
require "app/graphql/types/base_interface"
require "app/graphql/types/base_scalar"
require "app/graphql/types/base_union"
# the node type is a special type which is qequired for a
# standards compliant server, it uses global ids for fetching
# any available object
require "app/graphql/types/node_type"
# base classes for mutations and subscriptions
require "app/graphql/mutations/base_mutation"
require "app/graphql/subscriptions/base_subscription"
# the base schema and root types, the main business logic is
# contained within these classes, so that we can easily recreate
# the server from within our specs..
require "app/graphql/schema_base/queries_base"
require "app/graphql/schema_base/mutations_base"
require "app/graphql/schema_base/subscriptions_base"
require "app/graphql/schema_base"
# the schema and root types
require "app/graphql/schema/queries"
require "app/graphql/schema/mutations"
require "app/graphql/schema/subscriptions"
require "app/graphql/schema"

recursive_require "lib/app/mutations/**/*.rb"

recursive_require "lib/platformer/constants/**/*.rb"

require "platformer/class_map"

require "platformer/documentation"
require "platformer/documentation/markdown"
require "platformer/documentation/arguments_documenter"
require "platformer/documentation/composer_class_documenter"
require "platformer/documentation/dsl_documenter"
require "platformer/documentation/dsl_method_documenter"

recursive_require "lib/platformer/shared_dsl_configuration/**/*.rb"

recursive_require "lib/platformer/dsls/**/*.rb"

recursive_require "lib/platformer/dsl_readers/**/*.rb"

require "app/platform_base"
require "app/platform_model"
require "app/platform_schema"
require "app/platform_callback"
require "app/platform_service"

require "platformer/parsers/for_field_macros"
require "platformer/parsers/all_models"
require "platformer/parsers/all_models/for_fields"
require "platformer/parsers/final_models"
require "platformer/parsers/final_models/for_fields"
require "platformer/parsers/schemas"

# composers, run in the required order
recursive_require "lib/platformer/composers/active_record/**/*.rb"
recursive_require "lib/platformer/composers/graphql/**/*.rb"

require "platformer/composers/migrations/create_structure"
recursive_require "lib/platformer/composers/migrations/columns/**/*.rb"
recursive_require "lib/platformer/composers/migrations/indexes/**/*.rb"
recursive_require "lib/platformer/composers/migrations/associations/**/*.rb"
# the rest can be run in any order (and it's safe to require them twice)
recursive_require "lib/platformer/composers/**/*.rb"

# initialize the GraphQL server last, because it requires all the queries, mutations
# and subscriptions to been composed first
Schema.initialize_all

module Platformer
end
