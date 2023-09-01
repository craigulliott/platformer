module Platformer
  module Databases
    class UnexpectedServerTypeError < StandardError
    end

    class ExpectedSymbolError < StandardError
    end

    # Return the coresponding Server object from the provided name and type.
    #
    # The first time this method is called, it will build the required
    # Server object, which will load its configuration from
    # config/database.yaml
    def self.server server_type, server_name
      raise ExpectedSymbolError, "server_type must be a symbol, '#{server_type}' was provided" unless server_type.is_a? Symbol
      raise ExpectedSymbolError, "server_name must be a symbol, '#{server_name}' was provided" unless server_name.is_a? Symbol

      @servers ||= {}

      case server_type
      # postgres database servers
      when :postgres
        @servers[:postgres] ||= {}
        @servers[:postgres][server_name] ||= Postgres::Server.new(server_name)

      else
        raise UnexpectedServerTypeError, "Unexpected server type `#{server_type}` provided"
      end
    end

    # Clears the database configuration object, this is primarily used from witin
    # the test suite
    def self.clear_configuration
      @servers = {}
    end

    # returns an array of servers for the given type
    def self.servers server_type
      raise ExpectedSymbolError, "server_type must be a symbol, '#{server_type}' was provided" unless server_type.is_a? Symbol
      # return the servers for this type
      @servers && @servers[server_type]&.values || []
    end
  end
end
