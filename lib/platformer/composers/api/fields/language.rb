# frozen_string_literal: true

module Platformer
  module Composers
    module API
      module Fields
        class Language < Parsers::Models::ForFields
          for_field :language_field do |prefix:, api_definition_class:, serializer_class:|
            if api_definition_class
              api_reader = DSLReaders::API.new api_definition_class

              name_prepend = prefix.nil? ? "" : "#{prefix}_"

              [
                :"#{name_prepend}language_code",
                :"#{name_prepend}language",
                :"#{name_prepend}language_alpha3_code",
                :"#{name_prepend}language_english_name"
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
