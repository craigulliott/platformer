# frozen_string_literal: true

module Platformer
  module Composers
    module GraphQL
      module Schema
        module Fields
          class Currency < Parsers::FinalModels::ForFields
            for_field :currency_field do |name:, schema_class:, graphql_type_class:, allow_null:, comment_text:|
              schema_reader = DSLReaders::Schema.new schema_class

              if schema_reader.has_field? name
                graphql_type_class.field name, String, comment_text, null: allow_null
              end
            end
          end
        end
      end
    end
  end
end
