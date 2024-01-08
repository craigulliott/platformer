module Platformer
  # todo: not tested
  module Logger
    def self.included(klass)
      klass.extend(ClassMethods)
    end

    def log
      self.class.log
    end

    module ClassMethods
      def log
        @logger ||= Logger.logger(self)
      end
    end

    # private singleton methods below
    # these are not exposed on the main Platformer module
    def self.logger base_class
      unless @setup_complete
        setup
        @setup_complete = true
      end

      # return the logger for this class
      Logging.logger[base_class]
    end

    def self.setup
      # set the log level
      default_log_level = ENV["LOG_LEVEL"]&.to_sym || :warn
      Logging.logger.root.level = default_log_level

      # are we logging to stouot
      unless ENV["SKIP_STDOUT_LOGGING"]
        appender = Logging.appenders.stdout
        Logging.logger.root.add_appenders appender
      end

      # are we also logging to a file
      if ENV["LOG_TO_FILE"]
        appender = Logging.appenders.file(Platformer.root("log/platformer.log"))
        Logging.logger.root.add_appenders appender
      end
    end
  end
end
