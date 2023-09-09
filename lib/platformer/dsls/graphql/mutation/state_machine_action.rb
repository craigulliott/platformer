module Platformer
  module DSLs
    module GraphQL
      module Mutations
        module StateMachineAction
          def self.included klass
            klass.define_dsl :state_machine_action do
              description <<~DESCRIPTION
                Adds a mutation which coresponds to an action in a state machine for this model.
              DESCRIPTION

              requires :action_name, :symbol do
                import_shared :snake_case_name_validator

                description <<~DESCRIPTION
                  The name of an action within this models state machine.
                DESCRIPTION
              end

              optional :state_machine, :symbol do
                import_shared :snake_case_name_validator

                description <<~DESCRIPTION
                  If the state machine was given a custom name, then provide the name here.
                DESCRIPTION
              end
            end
          end
        end
      end
    end
  end
end
