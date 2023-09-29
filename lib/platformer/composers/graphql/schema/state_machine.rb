# frozen_string_literal: true

module Platformer
  module Composers
    module GraphQL
      module Schema
        module StateMachine
          warn "not tested"
          class StateMachine < Parsers::FinalModels
            for_dsl :state_machine do |name:, schema_definition_class:, graphql_type_class:, reader:|
              if schema_definition_class
                schema_reader = DSLReaders::Schema.new schema_definition_class

                column_name = name || :state

                description = reader.description&.description

                if schema_reader.has_field? column_name
                  graphql_type_class.field column_name, ::GraphQL::Types::String, description, null: false
                end
              end
            end
          end
        end
      end
    end
  end
end
