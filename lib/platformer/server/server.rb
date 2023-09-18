module Platformer
  class Server < Sinatra::Base
    use Rack::PostBodyContentTypeParser

    include Explorer
    include HealthCheck
    include GraphQL
  end
end
