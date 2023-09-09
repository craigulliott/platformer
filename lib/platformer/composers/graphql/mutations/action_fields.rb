# frozen_string_literal: true

module Platformer
  module Composers
    module GraphQL
      module Mutations
        # Create GraphQL Mutation classes to represent each of our action field actions.
        #
        # For example, if we have created a `Users::BadgesModel` with a `publish` action field, and
        # `publish` was called within the `Users::BadgesMutation`, then this composer will generate
        # a `Mutations::Users::PublishBadges` mutation and install it onto Schema::Mutations under the
        # `publish_user_badge` field
        class ActionFields < Parsers::Mutations
          class ActionFieldNotFoundError < StandardError
          end

          class FieldNotDefinedError < StandardError
          end

          # Process the parser for every final decendant of BaseMutation
          for_dsl :action do |public_name:, action_field_name:, model_reader:, mutation_definition_class:, graphql_type_class:, active_record_class:, presenter_class:|
            add_documentation <<~DESCRIPTION
              Create a GraphQL Mutation which corresponds to the `#{action_field_name}` action field on this model class.
            DESCRIPTION

            action_name = model_reader.action_field_action action_field_name

            if action_name.nil?
              raise ActionFieldNotFoundError, "Action Field `#{action_field_name} not found for this `#{mutation_definition_class.name}`"
            end

            field_names = []
            # get all the fields for this updater
            for_method :fields do |fields:|
              field_names += fields
            end

            mcb = Services::GraphQL::MutationClassBuilder.new mutation_definition_class, public_name, field_names, action_name.to_s.titleize, action_name
            graphql_mutation_class = mcb.mutation_class

            # install the field into the Schema::Mutations class
            field_name = :"#{action_name}_#{public_name}"
            ::Schema::Mutations.field field_name, mutation: graphql_mutation_class
          end
        end
      end
    end
  end
end
