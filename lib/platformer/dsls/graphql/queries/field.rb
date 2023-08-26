module Platformer
  module DSLs
    module GraphQL
      module Queries
        module Description
          def self.included klass
            klass.define_dsl :field do
              description <<~DESCRIPTION
                A field which should be exposed via the API.
              DESCRIPTION

              requires :model, :class do
                description <<~DESCRIPTION
                  The model which this query is accessing.
                DESCRIPTION
              end
            end
          end
        end
      end
    end
  end
end
