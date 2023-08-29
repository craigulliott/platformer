# frozen_string_literal: true

module Platformer
  module Composers
    module GraphQL
      module Schema
        # Create GraphQL Type classes to represent each model in the schema.
        #
        # For example, if we have created a UserSchema and an OrganizationSchema
        # which extend PlatformSchema, then this composer will generate a `Types::User`
        # and a `Types::Organization` class which are extended from Types::BaseObject
        class CreateTypes < Parsers::Schemas
          # Process the parser for every final decendant of PlatformSchema
          for_final_schemas do |model_class:|
            # if one was provided, then extract the description
            class_description = nil
            for_dsl :description do |description:|
              class_description = description
            end

            add_documentation <<~DESCRIPTION
              Create a GraphQL Types class which corresponds to this model class.
            DESCRIPTION

            graphql_type_class = ClassMap.create_graphql_type_class_from_model_class model_class

            # if a description is available, then set it on the graphql type object
            if class_description
              graphql_type_class.description class_description
            end
          end
        end
      end
    end
  end
end
