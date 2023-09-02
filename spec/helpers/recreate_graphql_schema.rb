module Helpers
  class RecreateGraphQLSchema
    def initialize
      @class_spec_helper = ClassSpecHelper.new
    end

    # Destroys the graphql schema and recreates it.
    #
    # You should call `recreate_graphql_schema` before dynamically creating
    # any new types and queries which you want to test against in your spec.
    # Once you have created your schema, but before you execute your actual
    # spec, remember to call `Schema.initialize!`
    def recreate
      @class_spec_helper.destroy_class ::Schema::Queries
      @class_spec_helper.destroy_class ::Schema::Mutations
      @class_spec_helper.destroy_class ::Schema::Subscriptions
      @class_spec_helper.destroy_class ::Schema

      eval <<~RUBY, binding, __FILE__, __LINE__ + 1
        class ::Schema < SchemaBase
          class Queries < QueriesBase
          end
          class Mutations < MutationsBase
          end
          class Subscriptions < SubscriptionsBase
          end
        end
      RUBY
    end
  end
end
