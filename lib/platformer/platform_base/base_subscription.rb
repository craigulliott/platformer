module Platformer
  class BaseSubscription < Base
    class InvalidSubscriptionClassName < StandardError
      def message
        "Subscription class names must end with 'Subscription'"
      end
    end

    describe_class <<~DESCRIPTION
      Create subscription definitions in platform/subscriptions
    DESCRIPTION

    # Add descriptions to your classes
    include Platformer::DSLs::Description

    # all subscription class names must end with "Subscription"
    def self.inherited subclass
      super
      raise InvalidSubscriptionClassName unless subclass.name.end_with? "Subscription"
    end
  end
end
