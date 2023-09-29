# frozen_string_literal: true

module Platformer
  module Composers
    module GraphQL
      module Schema
        warn "not tested"
        class Connection < Parsers::Schemas
          for_dsl :connection do |foreign_model:, association_name:, model_reader:, model_definition_class:, graphql_type_class:|
            name = association_name || foreign_model.active_record_class.name.split("::").last.underscore.pluralize.to_sym
            graphql_type_class.field name, foreign_model.graphql_type_class.connection_type # todo , description, null: allow_null
          end
        end
      end
    end
  end
end
