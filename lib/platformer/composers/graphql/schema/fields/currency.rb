# frozen_string_literal: true

module Platformer
  module Composers
    module GraphQL
      module Schema
        module Fields
          class Currency < Parsers::FinalModels::ForFields
            for_field :currency_field do |prefix:, schema_definition_class:, graphql_type_class:, allow_null:, comment_text:|
              if schema_definition_class
                schema_reader = DSLReaders::Schema.new schema_definition_class

                name_prepend = prefix.nil? ? "" : "#{prefix}_"

                currency_name_field_name = :"#{name_prepend}currency_name"
                if schema_reader.has_field? currency_name_field_name
                  graphql_type_class.field currency_name_field_name, String, comment_text, null: allow_null
                end

                currency_code_field_name = :"#{name_prepend}currency_code"
                if schema_reader.has_field? currency_code_field_name
                  # find or create the shared grahql enum class
                  ecs = Services::GraphQL::EnumCreator.new(:currency_code)
                  enum_class = ecs.find_or_create Constants::ISO::CurrencyCode.values
                  # add the field
                  graphql_type_class.field currency_code_field_name, enum_class, comment_text, null: allow_null
                end

              end
            end
          end
        end
      end
    end
  end
end
