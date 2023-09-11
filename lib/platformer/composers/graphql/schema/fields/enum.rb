# frozen_string_literal: true

module Platformer
  module Composers
    module GraphQL
      module Schema
        module Fields
          class Enum < Parsers::FinalModels::ForFields
            for_field :enum_field do |name:, values:, public_name:, schema_definition_class:, graphql_type_class:, allow_null:, comment_text:|
              if schema_definition_class
                schema_reader = DSLReaders::Schema.new schema_definition_class

                if schema_reader.has_field? name
                  # find or create the shared grahql enum class
                  ecs = Services::GraphQL::EnumCreator.new(name, public_name)
                  enum_class = ecs.find_or_create values
                  # add the field
                  graphql_type_class.field name, enum_class, comment_text, null: allow_null
                end
              end
            end
          end
        end
      end
    end
  end
end
