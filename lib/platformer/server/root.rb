module Platformer
  module Server
    class Root < Grape::API
      mount Routes::Explorer
      mount Routes::HealthCheck
      mount Routes::GraphQL
      mount Routes::JSONAPI
    end
  end
end
