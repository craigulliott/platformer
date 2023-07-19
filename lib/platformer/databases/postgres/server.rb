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

        # create a new representation of a postgres server
        def initialize name
          @name = name
          @databases = {}

          # get all the configuration values
          @host = Configuration.require_value(:postgres, name, :host)
          @port = Configuration.require_value(:postgres, name, :port)
          @username = Configuration.require_value(:postgres, name, :username)
          @default_database = Configuration.require_value(:postgres, name, :default_database).to_sym
          @password = Configuration.value(:postgres, name, :password)

          # the DynamicMigrations representation of the server
          @structure = DynamicMigrations::Postgres::Server.new(@host, @port, @username, @password)
        end

        # return a specific database on this server, if this database has
        # not been referenced before, then it will be created
        def database name
          @databases[name] ||= Database.new(self, name)
        end

        # return the default database on this server, if this database has
        # not been referenced before, then it will be created
        def default_database
          database @default_database
        end
      end
    end
  end
end
