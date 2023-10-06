# frozen_string_literal: true

module Platformer
  module Composers
    module GraphQL
      module Schema
        module Fields
          class Country < Parsers::Models::ForFields
            for_field :country_field do |prefix:, schema_definition_class:, graphql_type_class:, allow_null:, description:|
              if schema_definition_class
                schema_reader = DSLReaders::Schema.new schema_definition_class

                name_prepend = prefix.nil? ? "" : "#{prefix}_"

                [
                  :"#{name_prepend}country_code",
                  :"#{name_prepend}country_alpha3_code",
                  :"#{name_prepend}country_name",
                  :"#{name_prepend}country_full_name",
                  :"#{name_prepend}country_subregion",
                  :"#{name_prepend}country_continent"
                ].each do |name|
                  if schema_reader.has_field? name
                    graphql_type_class.field name, String, description, null: allow_null
                  end
                end

                country_field_name = :"#{name_prepend}country"
                if schema_reader.has_field? country_field_name
                  # find or create the shared graphql enum class
                  ecs = Services::GraphQL::EnumCreator.new(:country)
                  enum_class = ecs.find_or_create Constants::ISO::Country.values
                  # add the field
                  graphql_type_class.field country_field_name, enum_class, description, null: allow_null
                end

              end
            end
          end
        end
      end
    end
  end
end
