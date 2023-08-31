module Platformer
  module DSLs
    module GraphQL
      module Mutations
        module Action
          def self.included klass
            klass.define_dsl :action do
              description <<~DESCRIPTION
                Adds a mutation based on one of this models action fields.
              DESCRIPTION

              requires :action_field, :symbol do
                description <<~DESCRIPTION
                  The name of the action field which this action is for
                DESCRIPTION
              end
            end
          end
        end
      end
    end
  end
end
