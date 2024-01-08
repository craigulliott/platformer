# frozen_string_literal: true

module Platformer
  module Composers
    module API
      # Expose a GET /resource/id endpoint for the corresponding model
      class Get < Parsers::APIs
        # Process the parser for every final decendant of BaseAPI which calls the get DSL
        for_dsl :get do |model_reader:, model_definition_class:, active_record_class:, presenter_class:, serializer_class:|
          resource_name = model_reader.public_name.pluralize

          # controller to fetch, serialize and return the record
          get_controller = lambda do
            model = active_record_class.find params[:id]
            presenter = presenter_class.new model
            JSONAPI::Serializer.serialize(presenter)
          end

          # add this GET /resource/id onto the Server::Routes::JSONAPI grape class
          Server::Routes::JSONAPI.resource resource_name do
            params do
              requires :id, uuid: true, desc: "ID of the #{resource_name}"
            end
            route_param :id do
              get(&get_controller)
            end
          end
        end
      end
    end
  end
end
