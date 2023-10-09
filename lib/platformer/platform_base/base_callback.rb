module Platformer
  class BaseCallback < Base
    class InvalidCallbackClassName < StandardError
      def message
        "Callback class names must end with 'Callback'"
      end
    end

    describe_class <<~DESCRIPTION
      Create callback definitions in platform/callbacks
    DESCRIPTION

    # Add descriptions to your classes
    include Platformer::DSLs::Description

    include Platformer::DSLs::Callbacks::AfterStageChange

    # all callback class names must end with "Callback"
    def self.inherited subclass
      super
      raise InvalidCallbackClassName unless subclass.name.end_with? "Callback"
    end
  end
end
