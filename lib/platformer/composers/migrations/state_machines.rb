# frozen_string_literal: true

module Platformer
  module Composers
    module Migrations
      class StateMachines < Parsers::FinalModels
        class MissingStatesError < StandardError
        end

        for_dsl :state_machine do |name:, schema:, table:, log_transitions:, comment:|
          state_machine_name = name || :state
          enum_type_name = name.nil? ? :"#{table.name}__states" : :"#{table.name}__#{name}_states"

          # process each state and build an array of the state names
          state_names = []
          for_method :state do |name:, requires_presence_of:, requires_absence_of:, comment:|
            state_names << name
          end

          unless state_names.count >= 2
            raise MissingStatesError, "The `#{state_machine_name}` state machine for `#{table.schema.name}`.`#{table.name}` must have at least 2 states"
          end

          # update the dynamic documentation
          add_documentation <<~DESCRIPTION
            Update DynamicMigrations and add an enum column named `#{name}` to
            the `#{table.schema.name}'.'#{table.name}` table. This column is used to
            track the current state of the state machine named `#{name}`. The column
            can never be NULL, and has to be one of '#{state_names.join("', '")}'.
          DESCRIPTION

          schema.add_enum enum_type_name, state_names, description: <<~COMMENT
            This type is for the `#{state_machine_name}` state machine on the
            `#{table.schema.name}'.'#{table.name}` table.
          COMMENT

          # add the column to the DynamicMigrations table
          table.add_column state_machine_name, enum_type_name, null: false, description: <<~COMMENT
            #{comment}
            This column represents the current state machine state. Possible values are #{state_names.to_sentence}.
          COMMENT
        end
      end
    end
  end
end
