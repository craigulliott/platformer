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

require "app/application_record"
require "app/platform_base"
require "app/platform_model"
require "app/platform_callback"
require "app/platform_service"

require "platformer/parsers/for_field_macros"
require "platformer/parsers/all_models"
require "platformer/parsers/all_models/for_fields"
require "platformer/parsers/final_models"
require "platformer/parsers/final_models/for_fields"

# composers, run in the required order
recursive_require "lib/platformer/composers/active_record/**/*.rb"
recursive_require "lib/platformer/composers/graphql/**/*.rb"

require "platformer/composers/migrations/create_structure"
recursive_require "lib/platformer/composers/migrations/columns/**/*.rb"
recursive_require "lib/platformer/composers/migrations/indexes/**/*.rb"
recursive_require "lib/platformer/composers/migrations/associations/**/*.rb"
# the rest can be run in any order (and it's safe to require them twice)
recursive_require "lib/platformer/composers/**/*.rb"

module Platformer
end
