# frozen_string_literal: true

module Platformer
  module Composers
    module GraphQL
      module Types
        module Fields
          class Json < Parsers::FinalModels::ForFields
            for_field :json_field do |name:, graphql_type:, allow_null:, comment_text:|
              graphql_type.field name, String, comment_text, null: allow_null
            end
          end
        end
      end
    end
  end
end
