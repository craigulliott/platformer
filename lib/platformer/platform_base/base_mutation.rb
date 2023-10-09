module Platformer
  class BaseMutation < Base
    class InvalidMutationClassName < StandardError
      def message
        "Mutation class names must end with 'Mutation'"
      end
    end

    describe_class <<~DESCRIPTION
      Create mutation definitions in platform/mutations
    DESCRIPTION

    # Add descriptions to your classes
    include Platformer::DSLs::Description

    include Platformer::DSLs::GraphQL::Mutations::Create
    include Platformer::DSLs::GraphQL::Mutations::Update
    include Platformer::DSLs::GraphQL::Mutations::Action
    include Platformer::DSLs::GraphQL::Mutations::StateMachineAction

    # all mutation class names must end with "Mutation"
    def self.inherited subclass
      super
      raise InvalidMutationClassName unless subclass.name.end_with? "Mutation"
    end
  end
end
