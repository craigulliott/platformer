module Platformer
  class Server < Sinatra::Base
    module HealthCheck
      def self.included klass
        klass.get "/health_check" do
          message = {success: true, message: "OK"}
          json message
        end
      end
    end
  end
end
