# frozen_string_literal: true

module Platformer
  # Recursively require all the files in the specified path, base should be set
  # to __dir__ in the file that calls this method.
  # The files are required alphabetically, and by depth. The shallowest depth first.
  #
  # For example, in the folder structure below, the files would be required in the same
  # order as they are written.
  #
  # platform/
  # ├─ file_a.rb
  # ├─ file_b.rb
  # ├─ folder_a/
  # │  ├─ file_a.rb
  # │  ├─ file_b.rb
  # ├─ folder_b/
  # │  ├─ file_a.rb
  # │  ├─ file_b.rb
  #
  def self.recursive_require_relative path, base
    # get all ruby files within the provided path
    files = Dir[File.expand_path("#{path}/**/*.rb", base)]

    # sort the paths by name
    files.sort!

    # now that they are guaranteed to be sorted alphabetically, we resort them by depth (shallowest first)
    files.sort_by! { |path| path.scan("/").length }

    # require each file
    files.each do |f|
      require_relative f
    end
  end
end

require "byebug"

# flexible logging library based on design of log4j
require "logging"

require "dsl_compose"
require "dynamic_migrations"

# require "bcrypt"
# # the default is 10, but 12 is fast enough and much more secure
# BCrypt::Engine.cost = 12

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

# rails GlobalID provides a unique ID for every object, and ability to easily load
# objects based on these IDs. We use it in conjunction with GraphQL to make our server
# relay compatible
require "globalid"

# graphql
require "graphql"

# sinatra is a thin webserver built on top of rack
require "sinatra/base"
require "sinatra/json"

# required for parsing json request bodies
require "rack/contrib"

# the base class which all active record models extend from
# and any active record exensions / plugins
require_relative "application_record/application_record"

require_relative "platformer/all"

# GraphQL schema and base types
require_relative "schema/all"

# the base Presenter which all other presenters extend from
require_relative "presenters/base"

module Platformer
  include Logger
  include Environment
  include Root
  include LoadTasks

  BASE_TYPES = [
    :model,
    :schema,
    :mutator,
    :subscription,
    :presenter,
    :policy,
    :callback,
    :job,
    :service
  ]

  # The composers parse the DSL's and dynamically create the platform. This must occur
  # after the platformer environment has been configured and all of the app files have
  # been loaded.
  def self.compose!
    require_relative "platformer/composers/all"
  end

  # compose and initialize the platform
  def self.initialize!
    log.info "Connecting to default postgres database"

    # Connect to the default postgres database
    ApplicationRecord.establish_connection(Platformer::Databases.server(:postgres, :primary).default_database.active_record_configuration)

    # run all the composers
    log.info "Running all composers"
    compose!

    # initialize the GraphQL server last, because it requires all the queries, mutations
    # and subscriptions to been composed first
    log.info "Initializing GraphQL server"
    Schema.initialize!
  end
end
