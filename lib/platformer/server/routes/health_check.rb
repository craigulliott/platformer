module Platformer
  module Server
    module Routes
      class HealthCheck < Grape::API
        format :json

        get :health_check do
          {
            success: true,
            message: "OK"
          }
        end
      end
    end
  end
end
