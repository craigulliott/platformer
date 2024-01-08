module Platformer
  module Server
    module Routes
      class GraphQL < Grape::API
        format :json
        content_type :json, "application/json"

        # shared controller over GET and POST HTTP methods
        graphql_controller = lambda do
          query = params[:query]
          context = {
            current_user: nil
          }
          # execute the schema
          Schema.execute(
            query,
            # variables: params[:variables],
            context: context
          )
        end

        params do
          requires :query, type: String, desc: "The graphql query"
        end

        resource :graphql do
          # graphql should work over GET
          post(&graphql_controller)

          # graphql should also work over POST
          get(&graphql_controller)
        end
      end
    end
  end
end
