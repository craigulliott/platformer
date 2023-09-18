module Platformer
  class Server < Sinatra::Base
    module GraphQL
      def self.included klass
        klass.post "/graphql" do
          result = Schema.execute(
            params[:query],
            variables: params[:variables],
            context: {current_user: nil}
          )
          json result
        end
      end
    end
  end
end
