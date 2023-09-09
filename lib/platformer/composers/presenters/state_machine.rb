# frozen_string_literal: true

module Platformer
  module Composers
    module Presenters
      class StateMachine < Parsers::FinalModels
        warn "not tested"

        for_dsl :state_machine do |name:, presenter_class:|
          column_name = name || :state

          presenter_class.add_presenter column_name

          for_method :state do |name:, comment:|
            state_name = name
            presenter_class.add_presenter :"#{state_name}?" do
              public_send(column_name) == state_name
            end
          end
        end
      end
    end
  end
end
