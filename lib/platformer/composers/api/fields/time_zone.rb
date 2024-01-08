# frozen_string_literal: true

module Platformer
  module Composers
    module API
      module Fields
        class TimeZone < Parsers::Models::ForFields
          for_field :time_zone_field do |prefix:, api_definition_class:, serializer_class:|
            if api_definition_class
              api_reader = DSLReaders::API.new api_definition_class

              name_prepend = prefix.nil? ? "" : "#{prefix}_"

              [
                :"#{name_prepend}time_zone",
                :"#{name_prepend}time_zone_name",
                :"#{name_prepend}time_zone_identifier"
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
