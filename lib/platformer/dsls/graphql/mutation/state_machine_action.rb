module Platformer
  module DSLs
    module GraphQL
      module Mutations
        module StateMachineAction
          def self.included klass
            klass.define_dsl :state_machine_action do
              description <<~DESCRIPTION
                Adds a mutation to state_machine_action a new record of this model.
              DESCRIPTION

              requires :action, :symbol do
              end

              optional :namespace, :symbol do
              end
            end
          end
        end
      end
    end
  end
end
