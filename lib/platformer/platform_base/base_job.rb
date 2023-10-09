module Platformer
  class BaseJob < Base
    class InvalidJobClassName < StandardError
      def message
        "Job class names must end with 'Job'"
      end
    end

    describe_class <<~DESCRIPTION
      Create job definitions in platform/jobs
    DESCRIPTION

    # Add descriptions to your classes
    include Platformer::DSLs::Description

    # all job class names must end with "Job"
    def self.inherited subclass
      super
      raise InvalidJobClassName unless subclass.name.end_with? "Job"
    end
  end
end
