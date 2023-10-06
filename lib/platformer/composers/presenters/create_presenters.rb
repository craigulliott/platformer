# frozen_string_literal: true

module Platformer
  module Composers
    module Presenters
      # Create Presenter classes to represent each of our model definitions.
      #
      # For example, if we have created a UserModel and an OrganizationModel
      # which extend BaseModel, then this composer will generate a `Presenters::User`
      # and a `Presenters::Organization` class which are extended from Presenters::Base
      class CreatePresenters < Parsers::Models
        # Process the parser for every decendant of BaseModel
        for_models do |model_definition_class:|
          add_documentation <<~DESCRIPTION
            Create a presenter class which wraps the ActiveRecord model and exposes the expected read methods
          DESCRIPTION

          presenter_definition_class_name = "Presenters::#{model_definition_class.name.gsub(/Model\z/, "")}"
          ClassMap.create_class presenter_definition_class_name, ::Presenters::Base
        end
      end
    end
  end
end
