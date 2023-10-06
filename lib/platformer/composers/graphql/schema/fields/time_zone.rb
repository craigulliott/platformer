# frozen_string_literal: true

module Platformer
  module Composers
    module GraphQL
      module Schema
        module Fields
          class TimeZone < Parsers::Models::ForFields
            for_field :time_zone_field do |prefix:, schema_definition_class:, graphql_type_class:, allow_null:, description:|
              if schema_definition_class
                schema_reader = DSLReaders::Schema.new schema_definition_class

                name_prepend = prefix.nil? ? "" : "#{prefix}_"

                [
                  :"#{name_prepend}time_zone_name",
                  :"#{name_prepend}time_zone_identifier"
                ].each do |name|
                  if schema_reader.has_field? name
                    graphql_type_class.field name, String, description, null: allow_null
                  end
                end

                time_zone_field_name = :"#{name_prepend}time_zone"
                if schema_reader.has_field? time_zone_field_name
                  # find or create the shared graphql enum class
                  ecs = Services::GraphQL::EnumCreator.new(:time_zone)
                  enum_class = ecs.find_or_create Constants::TimeZone.values
                  # add the field
                  graphql_type_class.field time_zone_field_name, enum_class, description, null: allow_null
                end

              end
            end
          end
        end
      end
    end
  end
end
