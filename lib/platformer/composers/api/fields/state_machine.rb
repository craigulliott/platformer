# frozen_string_literal: true

module Platformer
  module Composers
    module API
      module StateMachine
        # todo: not tested
        class StateMachine < Parsers::Models
          for_dsl :state_machine do |name:, api_definition_class:, serializer_class:|
            if api_definition_class
              api_reader = DSLReaders::API.new api_definition_class

              column_name = name || :state

              if api_reader.has_field? column_name
                serializer_class.attribute column_name
              end
            end
          end
        end
      end
    end
  end
end
