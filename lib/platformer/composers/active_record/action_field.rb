# frozen_string_literal: true

module Platformer
  module Composers
    module ActiveRecord
      class ActionField < Parsers::AllModels::ForFields
        class MethodAlreadyExistsError < StandardError
        end

        class ImpossibleActionError < StandardError
        end

        for_field :action_field do |name:, action_name:, active_record_class:|
          state_name = name
          inverse_state_name = :"un#{name}"
          boolean_column_name = :"un#{name}"
          timestamp_column_name = :"#{name}_at"
          inverse_action_name = :"un#{action_name}"
          action_method_name = action_name
          inverse_action_method_name = inverse_action_name

          # unless the state has already been switched, then default the boolean column
          # to TRUE, as this signifies that the action has not been performed yet
          active_record_class.before_validation on: :create do
            current_timestamp = send(timestamp_column_name)
            if current_timestamp.nil?
              send "#{boolean_column_name}=", true
            end
          end

          if active_record_class.respond_to? action_method_name
            raise MethodAlreadyExistsError, "The field name `#{column_name}` is reserved. An instance method of the same name already exists on this #{active_record_class.name}"
          end
          active_record_class.define_method action_method_name do
            # assert the model isn't already in the target state
            unless send(timestamp_column_name).nil?
              raise ImpossibleActionError, "This #{self.class.name} is already #{state_name}"
            end

            # update the model to show this action has occured
            send "#{boolean_column_name}=", nil
            send "#{timestamp_column_name}=", Time.now

            # save the record
            save
          end

          if active_record_class.respond_to? inverse_action_method_name
            raise MethodAlreadyExistsError, "The field name `#{column_name}` is reserved. An instance method of the same name already exists on this #{active_record_class.name}"
          end
          active_record_class.define_method inverse_action_method_name do
            # assert the model isn't already in the target state
            if send(timestamp_column_name).nil?
              raise ImpossibleActionError, "This #{self.class.name} is already #{inverse_state_name}"
            end

            # update the model to show this action has occured
            send "#{boolean_column_name}=", true
            send "#{timestamp_column_name}=", nil

            # save the record
            save
          end
        end
      end
    end
  end
end
