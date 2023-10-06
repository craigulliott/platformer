# frozen_string_literal: true

module Platformer
  module Composers
    module GraphQL
      module Schema
        module Fields
          class PhoneNumber < Parsers::Models::ForFields
            for_field :phone_number_field do |prefix:, schema_definition_class:, graphql_type_class:, allow_null:, description:|
              if schema_definition_class
                schema_reader = DSLReaders::Schema.new schema_definition_class

                name_prepend = prefix.nil? ? "" : "#{prefix}_"

                [
                  :"#{name_prepend}phone_number",
                  # note, dialing code can not be an ENUM because the values are numbers
                  :"#{name_prepend}dialing_code",
                  :"#{name_prepend}phone_number_formatted",
                  :"#{name_prepend}phone_number_international_formatted"
                ].each do |name|
                  if schema_reader.has_field? name
                    graphql_type_class.field name, String, description, null: allow_null
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
