# frozen_string_literal: true

module Platformer
  module Composers
    module GraphQL
      module Types
        module Fields
          class Boolean < Parsers::FinalModels::ForFields
            for_field :boolean_field do |name:, graphql_type:, allow_null:, comment_text:|
              graphql_type.field name, ::GraphQL::Types::Boolean, comment_text, null: allow_null
            end
          end
        end
      end
    end
  end
end
