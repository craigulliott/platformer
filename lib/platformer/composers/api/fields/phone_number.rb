# frozen_string_literal: true

module Platformer
  module Composers
    module API
      module Fields
        class PhoneNumber < Parsers::Models::ForFields
          for_field :phone_number_field do |prefix:, api_definition_class:, serializer_class:|
            if api_definition_class
              api_reader = DSLReaders::API.new api_definition_class

              name_prepend = prefix.nil? ? "" : "#{prefix}_"

              [
                :"#{name_prepend}phone_number",
                # note, dialing code can not be an ENUM because the values are numbers
                :"#{name_prepend}dialing_code",
                :"#{name_prepend}phone_number_formatted",
                :"#{name_prepend}phone_number_international_formatted"
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
