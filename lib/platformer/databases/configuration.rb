# frozen_string_literal: true

module Platformer
  module Databases
    module Configuration
      class MissingConfigurationError < StandardError
      end

      # returns the configuration value if it exists, else nil
      def self.value database_type, name, key
        if file_contents[database_type.to_s].nil?
          raise MissingConfigurationError, "no database configuration found for `#{database_type}` in database.yaml"
        end

        if file_contents[database_type.to_s][name.to_s].nil?
          raise MissingConfigurationError, "no configuration found for #{database_type}.#{name} in database.yaml"
        end

        file_contents[database_type.to_s][name.to_s][key.to_s]
      end

      # returns the configuration value if it exists, else raises an error
      def self.require_value database_type, name, key
        value(database_type, name, key) || raise(MissingConfigurationError, "no `#{key}` found for #{database_type}.#{name} in database.yaml")
      end

      # opens the configuration yaml file, and returns the contents as a hash
      # caches the result for future use
      def self.file_contents
        @@file_contents ||= YAML.load_file("config/database.yaml")
      end
    end
  end
end
