# frozen_string_literal: true

module Platformer
  module Databases
    module Postgres
      class Server
        class Database
          attr_reader :name
          attr_reader :server

          class MissingDatabaseNameError < StandardError
          end

          def initialize server, name
            raise MissingDatabaseNameError if name.nil?

            @server = server
            @name = name.to_sym

            # add the default database to the structure
            @server.structure.add_database @name
          end

          def structure
            @server.structure.database @name
          end

          # return the required configuration to create an active record connection with
          # this database
          def active_record_configuration
            {
              host: @server.host,
              port: @server.port,
              username: @server.username,
              password: @server.password,
              database: @name.to_s,
              encoding: "utf8",
              adapter: "postgis",
              schema_search_path: "public,postgis"
            }
          end

          # return the required configuration to create a pg connection with
          # this database
          def pg_configuration
            {
              host: @server.host,
              port: @server.port,
              username: @server.username,
              password: @server.password,
              database: @name
            }
          end
        end
      end
    end
  end
end
