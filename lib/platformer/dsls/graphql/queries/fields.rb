module Platformer
  module DSLs
    module GraphQL
      module Queries
        module Fields
          def self.included klass
            klass.define_dsl :fields do
              description <<~DESCRIPTION
                A list of the all this models scalar and enum fields which will be exposed via graphql.
              DESCRIPTION

              requires :fields, :symbol, array: true do
                description <<~DESCRIPTION
                  The names of this models fields to expose.
                DESCRIPTION
              end
            end
          end
        end
      end
    end
  end
end
