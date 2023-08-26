# frozen_string_literal: true

module Platformer
  module Composers
    module GraphQL
      module Types
        module Fields
          class IpAddress < Parsers::FinalModels::ForFields
            for_field :ip_address_field do |name:, graphql_type:, allow_null:, comment_text:|
              graphql_type.field name, String, comment_text, null: allow_null
            end
          end
        end
      end
    end
  end
end
