# frozen_string_literal: true

module Platformer
  module Composers
    module ActiveRecord
      class StateMachine < Parsers::AllModels
        class MissingStatesError < StandardError
        end

        class ReservedAttributeNameError < StandardError
        end

        for_dsl :state_machine do |name:, active_record_class:, log_transitions:, reader:|
          state_machine_name = name || :state
          namespace = (state_machine_name == :state) ? :state_machine : :"#{state_machine_name}_state_machine"

          comment = reader.comment&.comment

          add_documentation <<~DESCRIPTION
            Create a state machine with the name `#{state_machine_name}` on this active record model.
          DESCRIPTION

          add_documentation <<~DESCRIPTION
            #{comment}
            The state machine has the following states:
          DESCRIPTION

          # process each state and build a hash representation of them
          state_configurations = {}
          for_method :state do |name:, requires_presence_of:, requires_absence_of:, comment:|
            # generated documentation for this model
            add_documentation <<~DESCRIPTION
              `:#{name}`

              #{comment}
            DESCRIPTION
            # build the hash representation of the desired states
            state_configurations[name] = {
              requires_presence_of: requires_presence_of,
              requires_absence_of: requires_absence_of,
              comment: comment
            }
          end

          unless state_configurations.keys.count >= 2
            raise MissingStatesError, "The state machine for #{active_record_class.name} must have at least 2 states"
          end

          add_documentation <<~DESCRIPTION
            #{comment}
            The state machine has the following actions:
          DESCRIPTION

          # process each action and build a hash representation of them
          action_configurations = {}
          for_method :action do |name:, from:, to:, guards:, comment:|
            # generated documentation for this model
            add_documentation <<~DESCRIPTION
              `:#{name}`

              #{comment}
            DESCRIPTION

            if active_record_class.instance_methods.include? name
              raise ReservedAttributeNameError, "The field name `#{name}` is reserved. An instance method of the same name already exists on this #{active_record_class.name}"
            end

            # build the hash representation of the desired states
            action_configurations[name] = {
              from: from,
              to: to,
              guards: guards,
              comment: comment
            }
          end

          # require this module (ruby will ignore this if it is called
          # multiple times, so its safe to do here)
          require "aasm"

          # include AASM (Acts As State Machine) in the model
          active_record_class.send(:include, AASM)

          initial_state_name = state_configurations.keys.first

          # add the desired state machine
          active_record_class.aasm state_machine_name, column: state_machine_name, timestamps: true, create_scopes: false, whiny_persistence: false, namespace: namespace do
            # install the states
            state_configurations.keys.each do |state_name|
              state state_name, initial: state_name == initial_state_name
            end

            # install the events
            action_configurations.each do |action_name, action_configuration|
              event action_name do
                # build the transitions options in such a way that we only provide
                # the required options
                transitions_options = {
                  to: action_configuration[:to]
                }
                if action_configuration[:from].any?
                  transitions_options[:from] = action_configuration[:from]
                end
                if action_configuration[:guards].any?
                  transitions_options[:guards] = action_configuration[:guards]
                end
                transitions(**transitions_options)
              end
            end
          end
        end
      end
    end
  end
end
