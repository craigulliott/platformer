# frozen_string_literal: true

module Platformer
  module Composers
    module GraphQL
      module Schema
        module Fields
          class Currency < Parsers::FinalModels::ForFields
            for_field :currency_field do |prefix:, schema_definition_class:, graphql_type_class:, allow_null:, description:|
              if schema_definition_class
                schema_reader = DSLReaders::Schema.new schema_definition_class

                name_prepend = prefix.nil? ? "" : "#{prefix}_"

                [
                  :"#{name_prepend}currency_name",
                  :"#{name_prepend}currency_code",
                  :"#{name_prepend}currency_symbol"
                ].each do |name|
                  if schema_reader.has_field? name
                    graphql_type_class.field name, String, description, null: allow_null
                  end
                end

                currency_field_name = :"#{name_prepend}currency"
                if schema_reader.has_field? currency_field_name
                  # find or create the shared graphql enum class
                  ecs = Services::GraphQL::EnumCreator.new(:currency)
                  enum_class = ecs.find_or_create Constants::ISO::Currency.values
                  # add the field
                  graphql_type_class.field currency_field_name, enum_class, description, null: allow_null
                end

              end
            end
          end
        end
      end
    end
  end
end
