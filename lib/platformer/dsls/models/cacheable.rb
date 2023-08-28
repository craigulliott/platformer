module Platformer
  module DSLs
    module Models
      module Deletable
        def self.included klass
          klass.define_dsl :cacheable do
            description <<~DESCRIPTION
              Todo
            DESCRIPTION

            optional :scope, :symbol, array: true do
              description <<~DESCRIPTION
                Todo
              DESCRIPTION
            end
          end
        end
      end
    end
  end
end
