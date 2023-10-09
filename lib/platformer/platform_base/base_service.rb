module Platformer
  class BaseService < Base
    class InvalidServiceClassName < StandardError
      def message
        "Service class names must end with 'Service'"
      end
    end

    describe_class <<~DESCRIPTION
      Create service definitions in platform/services
    DESCRIPTION

    # Add descriptions to your classes
    include Platformer::DSLs::Description

    # all service class names must end with "Service"
    def self.inherited subclass
      super
      raise InvalidServiceClassName unless subclass.name.end_with? "Service"
    end
  end
end
