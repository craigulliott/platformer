module Platformer
  warn "not tested"
  module Logger
    def self.included(klass)
      klass.extend(ClassMethods)
    end

    module ClassMethods
      def log
        @logger ||= Logger.logger(self)
      end
    end

    # private singleton methods below
    # these are not exposed on the main Platformer module
    def self.logger base_class
      logger = Logging.logger[base_class]

      # set the log level
      logger.level = default_log_level

      # are we logging to stouot
      unless ENV["SKIP_STDOUT_LOGGING"]
        logger.add_appenders Logging.appenders.stdout
      end

      # are we also logging to a file
      if ENV["LOG_TO_FILE"]
        logger.add_appenders Logging.appenders.file(Platformer.root("log/platformer.log"))
      end

      # return the logger
      logger
    end

    def self.default_log_level
      ENV["LOG_LEVEL"]&.to_sym || :warn
    end

    def self.default_log_target
      ENV["LOG_TARGET"] || $stdout
    end
  end
end
