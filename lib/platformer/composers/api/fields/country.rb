# frozen_string_literal: true

module Platformer
  module Composers
    module API
      module Fields
        class Country < Parsers::Models::ForFields
          for_field :country_field do |prefix:, api_definition_class:, serializer_class:|
            if api_definition_class
              api_reader = DSLReaders::API.new api_definition_class

              name_prepend = prefix.nil? ? "" : "#{prefix}_"

              [
                :"#{name_prepend}country",
                :"#{name_prepend}country_code",
                :"#{name_prepend}country_alpha3_code",
                :"#{name_prepend}country_name",
                :"#{name_prepend}country_full_name",
                :"#{name_prepend}country_subregion",
                :"#{name_prepend}country_continent"
              ].each do |name|
                if api_reader.has_field? name
                  serializer_class.attribute name
                end
              end
            end
          end
        end
      end
    end
  end
end
