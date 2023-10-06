# frozen_string_literal: true

module Platformer
  module Composers
    module GraphQL
      module Schema
        module Fields
          class Language < Parsers::Models::ForFields
            for_field :language_field do |prefix:, schema_definition_class:, graphql_type_class:, allow_null:, description:|
              if schema_definition_class
                schema_reader = DSLReaders::Schema.new schema_definition_class

                name_prepend = prefix.nil? ? "" : "#{prefix}_"

                [
                  :"#{name_prepend}language_code",
                  :"#{name_prepend}language_alpha3_code",
                  :"#{name_prepend}language_english_name"
                ].each do |name|
                  if schema_reader.has_field? name
                    graphql_type_class.field name, String, description, null: allow_null
                  end
                end

                language_field_name = :"#{name_prepend}language"
                if schema_reader.has_field? language_field_name
                  # find or create the shared graphql enum class
                  ecs = Services::GraphQL::EnumCreator.new(:language)
                  enum_class = ecs.find_or_create Constants::ISO::Language.values
                  # add the field
                  graphql_type_class.field language_field_name, enum_class, description, null: allow_null
                end

              end
            end
          end
        end
      end
    end
  end
end
