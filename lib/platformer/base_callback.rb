module Platformer
  class BaseCallback < Base
    class InvalidCallbackClassName < StandardError
      def message
        "Callback class names must end with 'Callback'"
      end
    end

    describe_class <<~DESCRIPTION
      Create query definitions in app/query to describe your queries
    DESCRIPTION

    # Add descriptions to your classes
    include Platformer::DSLs::Description

    include Platformer::DSLs::Callbacks::AfterStageChange

    # all query class names must end with "Callback"
    def self.inherited subclass
      raise InvalidCallbackClassName unless subclass.name.end_with? "Callback"
    end
  end
end
