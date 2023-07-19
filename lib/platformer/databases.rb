module Platformer
  module Databases
    # Return the PostgresServer object from the provided name.
    #
    # The first time this method is called, it will build the required
    # PostgresServer object, which will load its configuration from
    # config/database.yaml
    def self.postgres_server server_name
      @postgres_servers ||= {}
      @postgres_servers[server_name] ||= Postgres::Server.new(server_name)
    end

    # Clears the database configuration object, this is primarily used from witin
    # the test suite
    def self.clear_configuration
      @postgres_servers = {}
    end

    # returns an array of the servers
    def self.postgres_servers
      @postgres_servers ||= {}
      @postgres_servers.values
    end
  end
end
