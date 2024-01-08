module Platformer
  module DSLs
    module APIs
      module Get
        def self.included klass
          klass.define_dsl :get do
            description <<~DESCRIPTION
              Expose a GET /resource/id endpoint for returning a specific resource.
            DESCRIPTION
          end
        end
      end
    end
  end
end
