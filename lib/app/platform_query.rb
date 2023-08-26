class PlatformQuery < PlatformBase
  class InvalidQueryClassName < StandardError
    def message
      "Query class names must end with 'Query'"
    end
  end

  describe_class <<~DESCRIPTION
    Create query definitions in app/query to describe your queries
  DESCRIPTION

  # Add descriptions to your classes
  include Platformer::DSLs::Description

  # Postgres Database Connections and Schema selection
  include Platformer::DSLs::GraphQL::Queries::Field

  # all query class names must end with "Query"
  def self.inherited subclass
    raise InvalidQueryClassName unless subclass.name.end_with? "Query"
  end
end
