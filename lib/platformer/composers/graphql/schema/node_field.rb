# frozen_string_literal: true

module Platformer
  module Composers
    module GraphQL
      module Schema
        warn "not tested"
        class NodeField < Parsers::Schemas
          for_dsl :node_field do |foreign_model:, association_name:, model_reader:, model_definition_class:, graphql_type_class:|
            name = association_name || foreign_model.active_record_class.name.split("::").last.underscore.to_sym
            graphql_type_class.field name, foreign_model.graphql_type_class # todo , comment_text, null: allow_null
          end
        end
      end
    end
  end
end
