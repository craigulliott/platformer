# frozen_string_literal: true

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
  include Environment
  include Root
  include LoadTasks

  # The composers parse the DSL's and dynamically create the platform. This must occur
  # after the platformer environment has been configured and all of the app files have
  # been loaded.
  def self.compose!
    require_relative "platformer/composers/all"
  end

  # compose and initialize the platform
  def self.initialize!
    # run all the composers
    compose!

    # Connect to the default postgres database
    ApplicationRecord.establish_connection(Platformer::Databases.server(:postgres, :primary).default_database.active_record_configuration)

    # initialize the GraphQL server last, because it requires all the queries, mutations
    # and subscriptions to been composed first
    Schema.initialize!
  end
end
