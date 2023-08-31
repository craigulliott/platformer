module Platformer
  class BaseJob < Base
    class InvalidJobClassName < StandardError
      def message
        "Job class names must end with 'Job'"
      end
    end

    describe_class <<~DESCRIPTION
      Create query definitions in app/query to describe your queries
    DESCRIPTION

    # Add descriptions to your classes
    include Platformer::DSLs::Description

    # all query class names must end with "Job"
    def self.inherited subclass
      raise InvalidJobClassName unless subclass.name.end_with? "Job"
    end
  end
end
