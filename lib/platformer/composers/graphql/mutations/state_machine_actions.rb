# frozen_string_literal: true

module Platformer
  module Composers
    module GraphQL
      module Mutations
        # Create GraphQL Mutation classes to represent each of our state machine actions.
        #
        # For example, if we have created a `Users::ProjectsModel` with a `submit` action on a state
        # machine, and `submit` was called within the `Users::ProjectsMutation`, then this composer will
        # generate a `Mutations::Users::SubmitProjects` mutation and install it onto Schema::Mutations under the
        # `submit_user_project` field
        class StateMachineActions < Parsers::Mutations
          # Process the parser for every final decendant of BaseMutation
          for_dsl :state_machine_action do |public_name:, state_machine:, action_name:, model_reader:, mutation_definition_class:, graphql_type_class:, active_record_class:, presenter_class:|
            add_documentation <<~DESCRIPTION
              Create a GraphQL Mutation which corresponds to the `#{action_name}` action within the #{state_machine || "default state machine"} on this model class.
            DESCRIPTION

            field_names = []
            # get all the fields for this updater
            for_method :fields do |fields:|
              field_names += fields
            end

            mcb = Services::GraphQL::MutationClassBuilder.new mutation_definition_class, public_name, field_names, action_name.to_s.titleize, :"#{action_name}!"
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
