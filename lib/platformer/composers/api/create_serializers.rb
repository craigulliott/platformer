# frozen_string_literal: true

module Platformer
  module Composers
    module API
      # Create JSONAPI Serializer classes to represent each model in the API.
      #
      # For example, if we have created a Users::UserAPI then this composer will generate
      # a `Serializers::Users::User` class which extends Serializers::Base
      class CreateSerializers < Parsers::APIs
        # Process the parser for every final decendant of BaseAPI
        for_apis do |model_definition_class:, presenter_class:|
          add_documentation <<~DESCRIPTION
            Create a JSONAPI Serializer class which corresponds to this model class.
          DESCRIPTION

          serializer_class_name = "Serializers::#{model_definition_class.name.gsub(/Model\z/, "")}"

          # create the serializer class
          serializer_class = ClassMap.create_class serializer_class_name, Serializers::Base

          # add all of the presenters methods
          # todo - finish this
          serializer_class.attribute :my_integer

          # update the presenter to use this serializer for JSONAPI requests
          presenter_class.define_method(:jsonapi_serializer_class_name) { serializer_class.name }
        end
      end
    end
  end
end
