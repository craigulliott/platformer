# frozen_string_literal: true

module Platformer
  module Composers
    module GraphQL
      module Schema
        module Fields
          class Country < Parsers::FinalModels::ForFields
            for_field :country_field do |prefix:, schema_definition_class:, graphql_type_class:, allow_null:, comment_text:|
              if schema_definition_class
                schema_reader = DSLReaders::Schema.new schema_definition_class

                name_prepend = prefix.nil? ? "" : "#{prefix}_"

                [
                  :"#{name_prepend}country_name",
                  :"#{name_prepend}country_full_name",
                  :"#{name_prepend}country_subregion",
                  :"#{name_prepend}country_alpha2",
                  :"#{name_prepend}country_alpha3",
                  :"#{name_prepend}country_continent"
                ].each do |name|
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
  end
end
