# frozen_string_literal: true

module Platformer
  module Databases
    module Postgres
      class Server
        class Database
          class MissingDatabaseNameError < StandardError
          end

          class UnexpectedFunctionError < StandardError
          end

          class UnexpectedConstantError < StandardError
          end

          include Composers::MakeColumnImmutable
          include Composers::MakeColumnImmutableOnceSet
          include Composers::AddUniqueConstraint

          attr_reader :name
          attr_reader :server

          def initialize server, name
            raise MissingDatabaseNameError if name.nil?

            @server = server
            @name = name.to_sym

            # add the default database to the structure
            server.structure.add_database name

            # add the dyanmic migrations schema to the structure
            structure.add_configured_schema :dynamic_migrations
          end

          def structure
            server.structure.database name
          end

          # returns a reference to a shared postgres function, the first time
          # the function is referenced it will be created
          warn "not tested"
          def find_or_create_shared_function function_class
            unless function_class < Functions::Function
              raise UnexpectedFunctionError, function_class
            end

            function_name = function_class.function_name

            # if the function has not already been installed, then install it now
            unless platformer_schema.has_function?(function_name)
              platformer_schema.add_function function_name, function_class.definition, description: function_class.description
            end

            # return the function structure object
            platformer_schema.function function_name
          end

          # returns the name to a shared enum type (such as currency or language)
          # which is stored in the platformer schema
          warn "not tested"
          def find_or_create_shared_enum constant_class
            unless constant_class < Constants::Constant
              raise UnexpectedConstantError, constant_class
            end

            enum_name = constant_class.constant_name

            # return the enum object
            if platformer_schema.has_enum?(enum_name)
              platformer_schema.enum enum_name

            # if the enum has not already been installed, then install it now
            else
              platformer_schema.add_enum enum_name, constant_class.values, description: constant_class.description
            end
          end

          # ensure we have a provided extensions installed into the provided database
          warn "not tested"
          def ensure_postgres_extension extension_name
            unless structure.has_configured_extension? extension_name
              structure.add_configured_extension extension_name
            end
          end

          warn "not tested"
          def platformer_schema
            @platformer_schema ||= get_platformer_schema_structure
          end

          warn "not tested"
          def exists?
            server.with_connection do |connection|
              rows = connection.exec <<~SQL
                SELECT FROM pg_database WHERE datname = '#{name}'
              SQL
              rows.count > 0
            end
          end

          warn "not tested"
          def create!
            server.with_connection do |connection|
              connection.exec <<~SQL
                CREATE DATABASE #{name};
              SQL
            end
          end

          warn "not tested"
          def schema_names skip_public: false, skip_pg_schemas: true, skip_information_schema: true
            # create a temporary database connection and fetch the list of schema names
            rows = with_connection do |connection|
              connection.exec <<~SQL
                SELECT schema_name FROM information_schema.schemata;
              SQL
            end

            # turn them to symbols
            schema_names = rows.map { |r| r["schema_name"].to_sym }

            # optionally remove the public schema
            if skip_public
              schema_names.delete_if { |schema_name| schema_name == :public }
            end

            # optionally remove the internal pg_* schemas
            if skip_pg_schemas
              schema_names.delete_if { |schema_name| schema_name.start_with? "pg_" }
            end

            # optionally remove the internal :information_schema schema
            if skip_information_schema
              schema_names.delete_if { |schema_name| schema_name == :information_schema }
            end

            # return the list
            schema_names
          end

          # return the required configuration to create an ActiveRecord connection with
          # this database
          def active_record_configuration
            {
              host: server.host,
              port: server.port,
              username: server.username,
              password: server.password,
              database: name.to_s,
              encoding: "utf8",
              adapter: "postgis",
              schema_search_path: "public,postgis"
            }
          end

          # return the required configuration to create a PG connection (via the PG gem)
          # to this database
          def pg_configuration
            server.pg_configuration.merge(dbname: name)
          end

          # Opens a connection to the database, and yields the provided block
          # before automatically closing the connection again. This is useful for
          # executing one time queries against the database server, such as maintenance
          # tasks, but should not be used for normal database access when processing
          # things like API request or background jobs.
          def with_connection &block
            # create a temporary connection to the server
            connection = PG.connect(pg_configuration)

            # perform work with the connection
            result = yield connection

            # close the connection
            connection.close

            # return the result
            result
          end

          private

          def get_platformer_schema_structure
            # shared enums are stored in the dedicated platformer schema
            unless structure.has_configured_schema?(:platformer)
              structure.add_configured_schema :platformer
            end
            # return the schema
            structure.configured_schema(:platformer)
          end
        end
      end
    end
  end
end
