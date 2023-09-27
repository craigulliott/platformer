# frozen_string_literal: true

module Platformer
  module Composers
    module Presenters
      class SoftDeletable < Parsers::FinalModels
        warn "not tested"

        for_dsl :soft_deletable do |presenter_class:|
          # deleted
          presenter_class.add_presenter :deleted do
            model.deleted?
          end

          # deleted_at
          presenter_class.add_presenter :deleted_at
        end
      end
    end
  end
end
