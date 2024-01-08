# frozen_string_literal: true

module Platformer
  module Generators
    module FromGrape
      class Generate
        include Logger

        def generate
          log.info "Generating APIs from JSON Dump"
          generate_apis

          log.info "Completed Generation"
        end

        private

        def generate_apis
          schemas = {}
          SCHEMA.each do |model_class_name, definition|
            schema_name = model_class_name.to_s.split("::").first.underscore
            unless schemas[schema_name]
              schemas[schema_name] = true
              # the base class which all apis in this schema extend from
              APIs::BaseAPI.new(schema_name).write_to_file true
            end

            # generate the api for each model in this schema
            APIs::API.new(schema_name, definition).write_to_file true
          end
        end
      end
    end
  end
end
