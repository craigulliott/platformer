module Platformer
  module Services
    module GraphQL
      class MutationClassBuilder
        class FieldNotDefinedError < StandardError
        end

        attr_reader :mutation_class

        def initialize model_definition_class, public_name, field_names, action_name, persistence_method_name
          @model_definition_class = model_definition_class
          @public_name = public_name
          @field_names = field_names
          @action_name = action_name
          @persistence_method_name = persistence_method_name

          # build the class
          @mutation_class = raw_mutation_class

          # configure it and add the argument fields
          configure_mutation_class
          add_mutation_class_arguments
        end

        private

        def configure_mutation_class
          # fetch the model by it's global id
          @mutation_class.argument :id, ::GraphQL::Types::ID, loads: graphql_type_class, as: :model

          # set the method name, so the resolve method knows which method to use when saving
          # this is just `:save` for the standard update, but will be something like `:publish`
          # for state machines, action fields, or deleting/undeleting records
          @mutation_class.persistence_method_name @persistence_method_name

          # Set the name of the model, this is used when building the response hash.
          # public_name is a name like `users_avatar` from a Users::AvatarModel, this name is aware
          # of the suppress_namespace DSL, and will return something like 'user' from Users::UserModel
          # if suppress_namespace was called when defining that model.
          @mutation_class.node_name @public_name

          # set the presenter class of the model, this is used when building the response hash
          @mutation_class.presenter_class presenter_class

          # even though the field  might be required, we always use the default `null: true` as this
          # allows us to support rich errors (errors detail across multiple fields, otherwise a non null
          # valiadation will cause graphql to abort the query before error messages can be generated)
          # more info: https://graphql-ruby.org/mutations/mutation_errors.html#nullable-mutation-payload-fields
          @mutation_class.field @public_name, graphql_type_class
        end

        # build and add all the arguments which this mutation accepts
        def add_mutation_class_arguments
          @field_names.each do |field_name|
            # get the field object from the graphql Type class associated with this model
            type_field = graphql_type_class.fields[field_name.to_s.camelize(:lower)]

            if type_field.nil?
              raise FieldNotDefinedError, "#{graphql_type_class.name} does not have a field named `#{field_name}`. If you want to allow this field to be accessable during #{@action_name} actions, then it must be added to the Schema definition."
            end

            # get the underlying type from the field (the process for this is different for null vs non null fields)
            type_class = type_field.type.non_null? ? type_field.type.of_type : type_field.type

            # create the corresponding argument field on this mutation
            @mutation_class.argument field_name, type_class, required: false
          end
        end

        # create the mutation class
        def raw_mutation_class
          ClassMap.create_class mutation_class_name, ::Mutations::UpdateMutation
        end

        # generate a name like "Mutations::Users::UpdateBadges" from "Users::Badges"
        def mutation_class_name
          "Mutations::#{active_record_class.name.sub(/(\w+)\z/, "#{@action_name}\\1")}"
        end

        def graphql_type_class
          @model_definition_class.graphql_type_class
        end

        def presenter_class
          @model_definition_class.presenter_class
        end

        def active_record_class
          @model_definition_class.active_record_class
        end
      end
    end
  end
end
