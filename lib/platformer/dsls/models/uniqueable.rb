module Platformer
  module DSLs
    module Models
      module Deletable
        def self.included klass
          klass.define_dsl :unique do
            description <<~DESCRIPTION
              Enforece that model is unique
            DESCRIPTION

            optional :scope, :symbol, array: true do
              description <<~DESCRIPTION
                The name of fields which this unique constraint should be scoped to.
              DESCRIPTION
            end
          end
        end
      end
    end
  end
end
