module Platformer
  module DSLs
    module Models
      module StateMachine
        def self.included klass
          klass.define_dsl :state_machine do
            description <<~DESCRIPTION
              A state machine simplifies the expression of business logic for a model
              by organizing it into distinct states and permitted transitions between
              those states. This is particularly useful for managing workflows, multi-step
              background processes, and asynchronous jobs. Use the state method to define
              the various states your model can occupy; the first state specified will
              serve as the default. Employ the event method to outline allowed transitions
              between states. While it's common to associate state machines with
              manually-triggered actions, like a user invoking :publish, they are also
              invaluable when integrated with callbacks, background jobs, webhooks, and
              external services.
            DESCRIPTION

            optional :name, :symbol do
              import_shared :snake_case_name_validator

              description <<~DESCRIPTION
                A name for this state machine. If you omit this option then the default
                name `:state` will be assumed. This option is typically only required if
                you need to have multiple state machines on the same model.
              DESCRIPTION
            end

            optional :log_transitions, :boolean do
              description <<~DESCRIPTION
                If set to true, a dedicated table will be created to automatically
                record transitions for this model. If the model is named `:projects`,
                the automatically generated table will be called `:project_transitions`.
              DESCRIPTION
            end

            import_shared :field_comment

            add_method :state do
              description <<~DESCRIPTION
                Add a state to your state machine. A state machine should comprise
                multiple states. The first state you define will serve as the default
                state for the machine.
              DESCRIPTION

              requires :name, :symbol do
                import_shared :snake_case_name_validator

                description <<~DESCRIPTION
                  Choose a name for the state that is preferably a past or present
                  participle. For example, use `:activated` or `:published` for stable
                  states and `:publishing` or `:activating` for transient, short-lived
                  states that are automatically transitioned away from. Crucially, avoid
                  using verbs like `:activate` or `:publish` for state names, as they
                  can conflict with your event names.
                DESCRIPTION
              end

              optional :comment, :symbol do
                description <<~DESCRIPTION
                  A description of this state. This description will be used when generating
                  documentation for your model.
                DESCRIPTION
              end

              optional :requires_presence_of, :symbol, array: true do
                import_shared :snake_case_name_validator

                description <<~DESCRIPTION
                  Specify an optional array of field names for the model, each of which
                  must contain a value when the model is in, or transitioning to, this
                  state. This requirement is common in state machines, as models often
                  accumulate data while advancing through different states. For instance,
                  transitioning to the `:published` state may necessitate that the
                  `:published_by` field includes a user.
                DESCRIPTION
              end

              optional :requires_absence_of, :symbol, array: true do
                import_shared :snake_case_name_validator

                description <<~DESCRIPTION
                  Specify an optional array of field names for this model. When the model
                  is in or transitioning to this state, these fields must be empty. For
                  instance, if the state machine is in the `:unpublished` state, the
                  `:published_by` field should have no user value.
                DESCRIPTION
              end
            end

            add_method :action do
              description <<~DESCRIPTION
                Create an action to outline permitted transitions between your model's
                states. Upon triggering, the action will sequentially evaluate and execute
                the first allowable transition. Any subscribed business logic, such as
                callbacks or messages, will then be executed. The model's internal state
                will update to the target state specified by the `to: :state` option, and
                any other pending changes will be saved. If no transitions are permissible,
                either due to a mismatch with the configured `from: [:state, :other_state]`
                or because any provided guards return false, then an error will be raised.
              DESCRIPTION

              requires :name, :symbol do
                import_shared :snake_case_name_validator

                description <<~DESCRIPTION
                  Choose a verb for your action name that clearly describes the action
                  required to transition between states. For instance, if your model
                  has `:reviewing` and `:published` states, a suitable action name for
                  transitioning would be `:publish`. If multiple actions share the same
                  name, they will be attempted in sequence and execution will halt at
                  the first successful transition.
                DESCRIPTION
              end

              requires :to, :symbol, kwarg: true do
                import_shared :snake_case_name_validator

                description <<~DESCRIPTION
                  Upon successful execution of this action, your model will transition to this state.
                DESCRIPTION
              end

              optional :comment, :symbol do
                description <<~DESCRIPTION
                  A description of this action. This description will be used when generating
                  documentation for your model.
                DESCRIPTION
              end

              optional :from, :symbol, array: true do
                import_shared :snake_case_name_validator

                description <<~DESCRIPTION
                  Specify an optional state name, or multiple state names, from which
                  this action is allowed to transition. If set, the action will only
                  be permitted if the model's current state matches one of the provided
                  states.
                DESCRIPTION
              end

              optional :guards, :symbol, array: true do
                import_shared :method_name_validator

                description <<~DESCRIPTION
                  Define a method name or multiple methods that must each return true
                  for the transition to be allowed. If any of the specified guards do
                  not return true, the system will attempt the next action with the
                  same name as the current one.
                DESCRIPTION
              end
            end
          end
        end
      end
    end
  end
end
