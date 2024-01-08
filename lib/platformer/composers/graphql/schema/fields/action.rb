# frozen_string_literal: true

module Platformer
  module Composers
    module GraphQL
      module Schema
        module Fields
          # todo: not tested
          class Action < Parsers::Models
            for_dsl :action_field do |name:, action_name:, schema_definition_class:, graphql_type_class:, reader:|
              if schema_definition_class
                schema_reader = DSLReaders::Schema.new schema_definition_class

                state_name = name
                inverse_state_name = :"un#{name}"
                timestamp_column_name = :"#{name}_at"

                description = reader.description&.description

                if schema_reader.has_field? state_name
                  graphql_type_class.field state_name, ::GraphQL::Types::Boolean, description, null: false
                end

                if schema_reader.has_field? inverse_state_name
                  graphql_type_class.field inverse_state_name, ::GraphQL::Types::Boolean, description, null: false
                end

                if schema_reader.has_field? timestamp_column_name
                  graphql_type_class.field timestamp_column_name, ::GraphQL::Types::ISO8601DateTime, description, null: true
                end
              end
            end
          end
        end
      end
    end
  end
end
