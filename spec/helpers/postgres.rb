require "pg_spec_helper"

module Helpers
  module Postgres
    # make pg_spec_helper conveniently accessible within our test suite
    def pg_helper
      ::Helpers::Postgres.pg_spec_helper
    end

    # default active record configuration
    def default_database_configuration
      ::Helpers::Postgres.default_database.active_record_configuration
    end

    # the configuration object for our test database (loaded from config/database.yaml)
    def self.default_database
      Platformer::Databases.server(:postgres, :primary).default_database
    end

    def self.initialize_database
      # ensure the database exists
      unless default_database.exists?
        warn "Creating database `#{default_database.name}`"
        default_database.create!
      end

      # ensure the dynamic_migrations schema exists
      unless default_database.schema_names.include? :dynamic_migrations
        warn "Creating schema `dynamic_migrations` in database `#{default_database.name}`"
        default_database.with_connection do |connection|
          connection.exec <<~SQL
            CREATE SCHEMA dynamic_migrations;
          SQL
        end
      end
    end

    # the pg spec helper, as a singleton method so it can be shared among the helper
    # class and also accessed from within the before(:suite) callbacks
    def self.pg_spec_helper
      if @pg_spec_helper.nil?
        @pg_spec_helper = PGSpecHelper.new(**default_database.pg_configuration)

        # don't delete the postgis schema between tests
        @pg_spec_helper.ignore_schema :postgis

        # don't delete the dynamic_migrations schema between tests
        @pg_spec_helper.ignore_schema :dynamic_migrations

        # this library uses several materialized_views to cache the structure of
        # the database, we need to refresh them whenever structure changes.
        # Structure cache:
        @pg_spec_helper.track_materialized_view :dynamic_migrations, :dynamic_migrations_structure_cache, [
          :create_schema,
          :create_table,
          :create_column
        ]
        # Keys and unique constraints cache:
        @pg_spec_helper.track_materialized_view :dynamic_migrations, :dynamic_migrations_keys_and_unique_constraints_cache, [
          :delete_all_schemas,
          :delete_tables,
          :create_foreign_key,
          :create_primary_key,
          :create_unique_constraint
        ]
        # Validations cache
        @pg_spec_helper.track_materialized_view :dynamic_migrations, :dynamic_migrations_validations_cache, [
          :delete_all_schemas,
          :delete_tables,
          :create_validation
        ]
      end
      @pg_spec_helper
    end
  end
end
