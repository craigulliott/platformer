module Platformer
  module DSLs
    module Models
      module GraphQL
        module RootNode
          def self.included klass
            klass.define_dsl :root_node
          end
        end
      end
    end
  end
end
