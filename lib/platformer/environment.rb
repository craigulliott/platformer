module Platformer
  module Environment
    class UnexpectedEnvironemntError < StandardError
    end

    def self.included(klass)
      klass.extend(ClassMethods)
    end

    module ClassMethods
      # returns either :production, :development or :test depending on the PLATFORMER_ENV setting
      def env
        @env ||= Environment.get_env
      end
    end

    # private singleton methods below
    # these are not exposed on the main Platformer module

    def self.get_env
      env_val = ENV["PLATFORMER_ENV"]&.to_sym || ENV["RACK_ENV"]&.to_sym || default_env
      unless [:production, :development, :test].include? env_val
        raise UnexpectedEnvironemntError, "Invalid environment `#{env_val}`. PLATFORMER_ENV or RACK_ENV must be set to either 'production', 'development' or 'test'"
      end
      env_val
    end

    def self.default_env
      warn "PLATFORMER_ENV or RACK_ENV is not set, defaulting to 'development'"
      :development
    end
  end
end
