# frozen_string_literal: true

module Platformer
  module Composers
    module API
      module Fields
        class IpAddress < Parsers::Models::ForFields
          for_field :ip_address_field do |name:, api_definition_class:, serializer_class:|
            if api_definition_class
              api_reader = DSLReaders::API.new api_definition_class

              if api_reader.has_field? name
                serializer_class.ip_attribute name
              end
            end
          end
        end
      end
    end
  end
end
