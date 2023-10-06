# frozen_string_literal: true

ENV["PLATFORMER_ENV"] = "test"

require_relative "../config/application"

require "byebug"
require "timecop"

require "helpers/postgres"
require_relative "helpers/scaffold"

# active record logging
# ActiveRecord::Base.logger = Logger.new($stdout)

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Remove the default exclusion pattern (show full backtraces by default)
  config.backtrace_exclusion_patterns = []

  config.include Helpers::Scaffold
  config.include Helpers::Postgres

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
      Helpers::Postgres.pg_spec_helper.reset! true
    else
      # raise an error unless the database structure is empty
      Helpers::Postgres.pg_spec_helper.assert_database_empty!
    end

    # make sure postgis has been installed
    Helpers::Postgres.pg_spec_helper.connection.exec <<-SQL
      CREATE SCHEMA IF NOT EXISTS postgis;
      GRANT ALL ON SCHEMA postgis TO PUBLIC;
      CREATE EXTENSION IF NOT EXISTS postgis WITH SCHEMA postgis;
    SQL
  end

  # Run the garbage collector before each test. This is nessessary because
  # we use `ObjectSpace` to determine class hieracy, and deleted classes will
  # still exist in ObjectSpace until the garbage collector runs
  config.before(:each) do
    ObjectSpace.garbage_collect
  end

  # use timecop to set the date and time to a known Friday July 14th 2023
  config.before(:each) do
    set_time_to = Time.utc(2023, 7, 14, 17, 0, 0)
    Timecop.travel(set_time_to)
  end

  # remove all classes which were created for specs
  config.after(:each) do
    destroy_dynamically_created_classes
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

  # put time back to where it was
  config.after(:each) do
    Timecop.return
  end

  # reset our database structure after each test (this deletes all
  # schemas and tables and then recreates the `public` schema)
  config.after(:each) do
    pg_helper.reset!
  end
end
