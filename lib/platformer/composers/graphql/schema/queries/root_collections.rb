# frozen_string_literal: true

module Platformer
  module Composers
    module GraphQL
      module Schema
        module Queries
          # Create GraphQL Query classes to represent each of our root collections.
          #
          # For example, if we have created a `Users::BadgesSchema` and root_collection was
          # called, then this composer will generate a `users_badge` field and install
          # it onto Schema::Queries.
          class RootCollection < Parsers::Schemas
            # Process the parser for every final decendant of BaseSchema
            for_dsl :root_collection do |schema_reader:, model_reader:, reader:, model_definition_class:, graphql_type_class:, active_record_class:|
              # the field name, such as `users` or `users_avatars`
              field_name = model_reader.public_name.pluralize

              arguments_metadata = []

              for_method :by_exact_string do |field_name:, required:|
                arguments_metadata << {
                  method: :by_exact_string,
                  field_name: field_name,
                  type: ::GraphQL::Types::String,
                  required: required
                }
              end

              # install the field into the Schema::Queries class
              ::Schema::Queries.field field_name, [graphql_type_class], "Find a post by ID", resolver_method: :fetch_collection_of_records, active_record_class: active_record_class, arguments_metadata: arguments_metadata, extras: [:graphql_name, :parent, :active_record_class, :arguments_metadata] do
                arguments_metadata.each do |am|
                  argument am[:field_name], am[:type], required: am[:required]
                end
              end
            end
          end
        end
      end
    end
  end
end
