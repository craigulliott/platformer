class SchemaBase < GraphQL::Schema
  class QueriesBase < GraphQL::Schema::Object
    # Add `node(id: ID!) and `nodes(ids: [ID!]!)`
    include GraphQL::Types::Relay::HasNodeField
    include GraphQL::Types::Relay::HasNodesField

    # our base field which includes our custom arguments
    # `active_record_class` is the ActiveRecord model class
    # `arguments_metadata` is metadata about the arguments which can be used
    #  to dynamically handle the select and where clauses
    field_class Types::BaseField

    def fetch_single_record(active_record_class:, arguments_metadata:, graphql_name:, parent:, **arguments)
      # todo - lots of work to do here
      arguments_metadata.each do |am|
        if am[:method] == :by_id
          id = arguments[am[:field_name]]
          model = active_record_class.find id
          return "Presenters::#{active_record_class.name}".constantize.new model
        end
      end
      raise "Could not find a method to load a record"
    end

    def fetch_collection_of_records(active_record_class:, arguments_metadata:, graphql_name:, parent:, **arguments)
      # todo - lots of work to do here
      presenter_class = "Presenters::#{active_record_class.name}".constantize
      arguments_metadata.each do |am|
        if am[:method] == :by_exact_string
          value = arguments[am[:field_name]]
          return active_record_class.where(am[:field_name] => value).map { |model| presenter_class.new model }
        end
        if am[:method] == :by_id
          value = arguments[am[:field_name]]
          return active_record_class.where(am[:field_name] => value).map { |model| presenter_class.new model }
        end
      end
      raise "Could not find a method to load a record"
    end
  end
end
