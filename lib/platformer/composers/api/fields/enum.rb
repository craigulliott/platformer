# frozen_string_literal: true

module Platformer
  module Composers
    module API
      module Fields
        class Enum < Parsers::Models::ForFields
          for_field :enum_field do |name:, values:, public_name:, api_definition_class:, serializer_class:|
            if api_definition_class
              api_reader = DSLReaders::API.new api_definition_class

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
