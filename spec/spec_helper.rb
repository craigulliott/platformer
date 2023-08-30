# frozen_string_literal: true

ENV["PLATFORMER_ENV"] = "test"

ENV["PLATFORMER_ROOT"] ||= File.expand_path("../", __dir__)

require "platformer"

Platformer.initialize!

require "class_spec_helper"
require "pg_spec_helper"
require_relative "helpers/recreate_graphql_schema"

# active record logging
# ActiveRecord::Base.logger = Logger.new($stdout)

CLASS_SPEC_HELPER = ClassSpecHelper.new

def create_class fully_qualified_class_name, base_class = nil, &block
  CLASS_SPEC_HELPER.create_class fully_qualified_class_name, base_class, &block
end

def destroy_class klass
  CLASS_SPEC_HELPER.destroy_class klass
end

RECREATE_GRAPHQL_SCHEMA = Helpers::RecreateGraphQLSchema.new

def recreate_graphql_schema
  RECREATE_GRAPHQL_SCHEMA.recreate_graphql_schema
end

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # the configuration for our test database (loaded from config/database.yaml)
  database_configuration = Platformer::Databases.server(:postgres, :primary).default_database

  # default active record configuration
  config.add_setting :default_database_configuration
  config.default_database_configuration = database_configuration.active_record_configuration

  # make pg_spec_helper conveniently accessible within our test suite
  config.add_setting :pg_spec_helper
  config.pg_spec_helper = PGSpecHelper.new(**database_configuration.pg_configuration)
  # dont modify the postgis schema
  config.pg_spec_helper.ignore_schema :postgis

  # this library uses several materialized_views to cache the structure of
  # the database, we need to refresh them whenever structure changes.
  # Structure cache:
  config.pg_spec_helper.track_materialized_view :public, :dynamic_migrations_structure_cache, [
    :create_schema,
    :create_table,
    :create_column
  ]
  # Keys and unique constraints cache:
  config.pg_spec_helper.track_materialized_view :public, :dynamic_migrations_keys_and_unique_constraints_cache, [
    :delete_all_schemas,
    :delete_tables,
    :create_foreign_key,
    :create_primary_key,
    :create_unique_constraint
  ]
  # Validations cache
  config.pg_spec_helper.track_materialized_view :public, :dynamic_migrations_validations_cache, [
    :delete_all_schemas,
    :delete_tables,
    :create_validation
  ]

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  # assert that our test suite is empty before running the test suite
  config.before(:suite) do
    # optionally provide DYNAMIC_MIGRATIONS_CLEAR_DB_ON_STARTUP=true to
    # force reset your database structure
    if ENV["DYNAMIC_MIGRATIONS_CLEAR_DB_ON_STARTUP"]
      config.pg_spec_helper.reset! true
    else
      # raise an error unless the database structure is empty
      config.pg_spec_helper.assert_database_empty!
    end
  end

  # Run the garbage collector before each test. This is nessessary because
  # we use `ObjectSpace` to determine class hieracy, and deleted classes will
  # still exist in ObjectSpace until the garbage collector runs
  config.before(:each) do
    ObjectSpace.garbage_collect
  end

  # remove all classes which were created for specs
  config.after(:each) do
    CLASS_SPEC_HELPER.remove_all_dynamically_created_classes
  end

  # if any tests create global configuration, then we need to clear it
  # between tests
  config.after(:each) do
    Platformer::Databases.clear_configuration
  end

  # after each spec, clear all the dynamic DSL executions
  config.after(:each) do
    Platformer::BaseModel.dsls.clear
  end

  # reset our database structure after each test (this deletes all
  # schemas and tables and then recreates the `public` schema)
  config.after(:each) do
    config.pg_spec_helper.reset!
  end
end
