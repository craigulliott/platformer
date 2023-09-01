module Platformer
  class Server < Sinatra::Base
    use Rack::PostBodyContentTypeParser

    get "/health_check" do
      message = {success: true, message: "OK"}
      json message
    end

    post "/graphql" do
      result = Schema.execute(
        params[:query],
        variables: params[:variables],
        context: {current_user: nil}
      )
      json result
    end
  end
end
