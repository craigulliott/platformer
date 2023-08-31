module Platformer
  class BaseService < Base
    class InvalidServiceClassName < StandardError
      def message
        "Service class names must end with 'Service'"
      end
    end

    describe_class <<~DESCRIPTION
      Create query definitions in app/query to describe your queries
    DESCRIPTION

    # Add descriptions to your classes
    include Platformer::DSLs::Description

    # all query class names must end with "Service"
    def self.inherited subclass
      raise InvalidServiceClassName unless subclass.name.end_with? "Service"
    end
  end
end
