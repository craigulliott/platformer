# frozen_string_literal: true

module Platformer
  module Composers
    module API
      module Fields
        class Float < Parsers::Models::ForFields
          for_field :float_field do |name:, api_definition_class:, serializer_class:|
            if api_definition_class
              api_reader = DSLReaders::API.new api_definition_class

              if api_reader.has_field? name
                serializer_class.float_attribute name
              end
            end
          end
        end
      end
    end
  end
end
