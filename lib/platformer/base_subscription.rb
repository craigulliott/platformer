module Platformer
  class BaseSubscription < Base
    class InvalidSubscriptionClassName < StandardError
      def message
        "Subscription class names must end with 'Subscription'"
      end
    end

    describe_class <<~DESCRIPTION
      Create query definitions in app/query to describe your queries
    DESCRIPTION

    # Add descriptions to your classes
    include Platformer::DSLs::Description

    # all query class names must end with "Subscription"
    def self.inherited subclass
      raise InvalidSubscriptionClassName unless subclass.name.end_with? "Subscription"
    end
  end
end
