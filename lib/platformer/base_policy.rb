module Platformer
  class BasePolicy < Base
    class InvalidPolicyClassName < StandardError
      def message
        "Policy class names must end with 'Policy'"
      end
    end

    describe_class <<~DESCRIPTION
      Create query definitions in app/query to describe your queries
    DESCRIPTION

    # Add descriptions to your classes
    include Platformer::DSLs::Description

    # all query class names must end with "Policy"
    def self.inherited subclass
      raise InvalidPolicyClassName unless subclass.name.end_with? "Policy"
    end
  end
end
