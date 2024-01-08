# frozen_string_literal: true

module Platformer
  module Composers
    module Presenters
      class ActionField < Parsers::Models
        # todo: not tested

        for_dsl :action_field do |name:, action_name:, presenter_class:|
          state_name = name
          inverse_state_name = :"un#{name}"
          timestamp_column_name = :"#{name}_at"

          # published, submitted, paid etc.
          presenter_class.add_presenter state_name do |model|
            model.public_send(inverse_state_name).nil?
          end

          # unpublished, unsubmitted, unpaid etc.
          presenter_class.add_presenter inverse_state_name do |model|
            model.public_send(inverse_state_name) == true
          end

          # published_at, submitted_at, paid_at etc.
          presenter_class.add_presenter timestamp_column_name
        end
      end
    end
  end
end
