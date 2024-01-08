# frozen_string_literal: true

module Platformer
  module Composers
    module API
      module Fields
        class Boolean < Parsers::Models::ForFields
          for_field :boolean_field do |name:, api_definition_class:, serializer_class:|
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
