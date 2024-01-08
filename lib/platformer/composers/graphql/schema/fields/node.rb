# frozen_string_literal: true

module Platformer
  module Composers
    module GraphQL
      module Schema
        module Fields
          # todo: not tested
          class Node < Parsers::Schemas
            for_dsl :node_field do |name:, model_reader:, model_definition_class:, graphql_type_class:|
              graphql_type_class.field name, model_reader.association_class!(name).graphql_type_class # todo , description, null: allow_null
            end
          end
        end
      end
    end
  end
end
