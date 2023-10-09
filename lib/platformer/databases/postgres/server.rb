# frozen_string_literal: true

module Platformer
  module Databases
    module Postgres
      class Server
        attr_reader :structure
        attr_reader :name
        attr_reader :host
        attr_reader :port
        attr_reader :username
        attr_reader :password

        # Create a new representation of a postgres server
        def initialize name
          @name = name
          @databases = {}

          # Get all the configuration values
          @host = Configuration.require_value(:postgres, name, :host)
          @port = Configuration.require_value(:postgres, name, :port)
          @username = Configuration.require_value(:postgres, name, :username)
          @default_database = Configuration.require_value(:postgres, name, :default_database).to_sym
          @password = Configuration.value(:postgres, name, :password)

          # The DynamicMigrations representation of the server
          @structure = DynamicMigrations::Postgres::Server.new(host, port, username, password)
        end

        # Return a specific database on this server, if this database configuration
        # object has not been referenced before, then it will be created
        def database name
          @databases[name] ||= Database.new(self, name)
        end

        # Returns an array of all the databases which have been configured
        # for this server
        def databases
          @databases.values
        end

        # Returns an array of all the database names which have been configured
        # for this server
        def database_names
          @databases.keys
        end

        # Return the default database on this server, if this database configuration
        # object has not been referenced before, then it will be created
        def default_database
          database @default_database
        end

        # return the required configuration to create a PG connection (via the PG gem)
        # to this database server
        def pg_configuration
          {
            host: host,
            port: port,
            user: username,
            password: password,
            sslmode: "prefer"
          }
        end

        # Opens a connection to the database server, and yields the provided block
        # before automatically closing the connection again. This is useful for
        # executing one time queries against the database server, such as maintenance
        # tasks, but should not be used for normal database access when processing
        # things like API request or background jobs. Note that this does not connect
        # to a specific database, for that you should use the equivilent method in the
        # database object.
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
      end
    end
  end
end
