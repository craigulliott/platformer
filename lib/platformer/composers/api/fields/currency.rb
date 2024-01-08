# frozen_string_literal: true

module Platformer
  module Composers
    module API
      module Fields
        class Currency < Parsers::Models::ForFields
          for_field :currency_field do |prefix:, api_definition_class:, serializer_class:|
            if api_definition_class
              api_reader = DSLReaders::API.new api_definition_class

              name_prepend = prefix.nil? ? "" : "#{prefix}_"

              [
                :"#{name_prepend}currency",
                :"#{name_prepend}currency_name",
                :"#{name_prepend}currency_code",
                :"#{name_prepend}currency_symbol"
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
