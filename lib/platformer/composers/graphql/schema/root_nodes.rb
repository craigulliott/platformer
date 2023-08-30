# frozen_string_literal: true

module Platformer
  module Composers
    module GraphQL
      module Schema
        # Create GraphQL Query classes to represent each of our root nodes.
        #
        # For example, if we have created a `Users::BadgesSchema` and root_node was
        # called, then this composer will generate a `users_badge` field and install
        # it onto Schema::Queries.
        class RootNode < Parsers::Schemas
          # Process the parser for every final decendant of BaseSchema
          for_dsl :root_node do |schema_reader:, reader:, model_class:, graphql_type_class:, active_record_class:|
            # the field name, such as `user` or `users_avatar`
            field_name = schema_reader.public_name

            arguments_metadata = []

            if reader.method_called? :by_id
              arguments_metadata << {
                method: :by_id,
                field_name: :id,
                type: ::GraphQL::Types::ID,
                required: true
              }
            end

            for_method :by_exact_string do |field_name:, required:|
              arguments_metadata << {
                method: :by_exact_string,
                field_name: field_name,
                type: ::GraphQL::Types::String,
                required: required
              }
            end

            # install the field into the Schema::Queries class
            ::Schema::Queries.field field_name, graphql_type_class, "Find a post by ID", resolver_method: :fetch_single_record, active_record_model_class: active_record_class, arguments_metadata: arguments_metadata, extras: [:graphql_name, :parent, :active_record_model_class, :arguments_metadata] do
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
