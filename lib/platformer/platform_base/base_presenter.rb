module Platformer
  class BasePresenter < Base
    class InvalidPresenterClassName < StandardError
      def message
        "Presenter class names must end with 'Presenter'"
      end
    end

    describe_class <<~DESCRIPTION
      Create presenters definitions in platform/presenters
    DESCRIPTION

    # Add descriptions to your classes
    include Platformer::DSLs::Description

    # all presenter class names must end with "Presenter"
    def self.inherited subclass
      raise InvalidPresenterClassName unless subclass.name.end_with? "Presenter"
    end
  end
end
