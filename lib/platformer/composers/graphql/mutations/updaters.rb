# frozen_string_literal: true

module Platformer
  module Composers
    module GraphQL
      module Mutations
        # Create GraphQL Mutation classes to represent each of our update mutations.
        #
        # For example, if we have created a `Users::BadgesMutation` and `update` was
        # called, then this composer will generate a `Mutations::Uses::UpdateBadges`
        # mutation and install it onto Schema::Mutations under the `update_user_badge` field
        class Updaters < Parsers::Mutations
          # Process the parser for every final decendant of BaseMutation
          for_dsl :update do |model_reader:, mutation_definition_class:, graphql_type_class:, active_record_class:|
            add_documentation <<~DESCRIPTION
              Create a GraphQL Mutation to update this class which corresponds to this model class.
            DESCRIPTION

            # generate a name like "Mutations::Uses::UpdateBadges" from "Uses::Badges"
            mutation_class_name = "Mutations::#{active_record_class.name.sub(/(\w+)\z/, 'Update\1')}"
            # create the mutation class
            graphql_mutation_class = ClassMap.create_class mutation_class_name, ::Mutations::BaseMutation

            # fetch the model by it's global id
            graphql_mutation_class.argument :id, ::GraphQL::Types::ID, loads: graphql_type_class, as: :model

            # build all the arguments which this mutation accepts
            graphql_mutation_class.argument :my_integer, ::GraphQL::Types::Int, required: true

            # set the active record model class, so the shared `update` method knows which class to fetch
            graphql_mutation_class.active_record_class active_record_class

            # Returns a name like `users_avatar` from a Users::AvatarModel, this method is aware of the
            # suppress_namespace DSL, and will return something like 'user' from Users::UserModel if
            # suppress_namespace was called when defining that model.
            public_name = model_reader.public_name

            # even though the field  might be required, we always use the default `null: true` as this
            # allows us to support rich errors (errors detail across multiple fields, otherwise a non null
            # valiadation will cause graphql to abort the query before error messages can be generated)
            # more info: https://graphql-ruby.org/mutations/mutation_errors.html#nullable-mutation-payload-fields
            graphql_mutation_class.field public_name, graphql_type_class

            # errors as data: https://graphql-ruby.org/mutations/mutation_errors.html#errors-as-data
            graphql_mutation_class.field :errors, [Types::ValidationError], null: false

            # use the shared update method from the base mutations class
            graphql_mutation_class.alias_method :resolve, :update

            # install the field into the Schema::Mutations class
            field_name = :"update_#{public_name}"
            ::Schema::Mutations.field field_name, mutation: graphql_mutation_class
          end
        end
      end
    end
  end
end
