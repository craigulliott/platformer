# frozen_string_literal: true

module Platformer
  module Composers
    module API
      module Fields
        # todo: not tested
        class ActionField < Parsers::Models
          for_dsl :action_field do |name:, action_name:, api_definition_class:, serializer_class:|
            if api_definition_class
              api_reader = DSLReaders::API.new api_definition_class

              state_name = name
              inverse_state_name = :"un#{name}"
              timestamp_column_name = :"#{name}_at"

              if api_reader.has_field? state_name
                serializer_class.attribute state_name
              end

              if api_reader.has_field? inverse_state_name
                serializer_class.attribute inverse_state_name
              end

              if api_reader.has_field? timestamp_column_name
                serializer_class.attribute timestamp_column_name
              end
            end
          end
        end
      end
    end
  end
end
