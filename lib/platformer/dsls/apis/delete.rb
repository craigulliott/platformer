module Platformer
  module DSLs
    module APIs
      module Delete
        def self.included klass
          klass.define_dsl :delete do
            description <<~DESCRIPTION
              Expose a DELETE /resource/id endpoint for returning a specific resource.
            DESCRIPTION

            optional :undeletable, :boolean do
              description <<~DESCRIPTION
                If undeletable is set to true, then a PUT endpoint will be exposed
                for the resource which allows the record to be restored, if a PUT
                endpoint already exists because the `update` DSL was used then the
                update endoint will be extended with this functionality.
              DESCRIPTION
            end
          end
        end
      end
    end
  end
end
