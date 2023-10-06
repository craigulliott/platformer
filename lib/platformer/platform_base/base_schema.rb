module Platformer
  class BaseSchema < Base
    class InvalidSchemaClassName < StandardError
      def message
        "Schema class names must end with 'Schema'"
      end
    end

    describe_class <<~DESCRIPTION
      Create schema definitions in platform/schemas
    DESCRIPTION

    # Add descriptions to your classes
    include Platformer::DSLs::Description

    # DSLs for defining graphyql queries from platformer models
    #
    # configure the fields and data available for each model
    include Platformer::DSLs::GraphQL::Queries::Fields
    include Platformer::DSLs::GraphQL::Queries::NodeField
    include Platformer::DSLs::GraphQL::Queries::Connection
    # make these objects available (either one, or a collection of them) at
    # the root of the GraphQL schema
    include Platformer::DSLs::GraphQL::Queries::RootNode
    include Platformer::DSLs::GraphQL::Queries::RootCollection

    # all schema class names must end with "Schema"
    def self.inherited subclass
      raise InvalidSchemaClassName unless subclass.name.end_with? "Schema"
    end
  end
end
