# frozen_string_literal: true

module Platformer
  module Composers
    module GraphQL
      module Mutations
        # Create GraphQL Mutation classes to represent each of our update mutations.
        #
        # For example, if we have created a `Users::BadgesMutation` and `update` was
        # called, then this composer will generate a `Mutations::Users::UpdateBadges`
        # mutation and install it onto Schema::Mutations under the `update_user_badge` field
        class Updaters < Parsers::Mutations
          # Process the parser for every final decendant of BaseMutation
          for_dsl :update do |reader:, model_reader:, public_name:, mutation_definition_class:, graphql_type_class:, active_record_class:, presenter_class:|
            add_documentation <<~DESCRIPTION
              Create a GraphQL Mutation to update this class which corresponds to this model class.
            DESCRIPTION

            field_names = []
            # get all the fields for this updater
            for_method :fields do |fields:|
              field_names += fields
            end

            mcb = Services::GraphQL::MutationClassBuilder.new mutation_definition_class, public_name, field_names, "Update", :save
            graphql_mutation_class = mcb.mutation_class

            # install the field into the Schema::Mutations class
            field_name = :"update_#{public_name}"
            ::Schema::Mutations.field field_name, mutation: graphql_mutation_class
          end
        end
      end
    end
  end
end
