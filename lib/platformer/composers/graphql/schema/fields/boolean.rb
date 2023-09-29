# frozen_string_literal: true

module Platformer
  module Composers
    module GraphQL
      module Schema
        module Fields
          class Boolean < Parsers::FinalModels::ForFields
            for_field :boolean_field do |name:, schema_definition_class:, graphql_type_class:, allow_null:, description:|
              if schema_definition_class
                schema_reader = DSLReaders::Schema.new schema_definition_class

                if schema_reader.has_field? name
                  graphql_type_class.field name, ::GraphQL::Types::Boolean, description, null: allow_null
                end
              end
            end
          end
        end
      end
    end
  end
end
