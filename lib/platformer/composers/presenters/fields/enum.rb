# frozen_string_literal: true

module Platformer
  module Composers
    module Presenters
      module Fields
        class Enum < Parsers::FinalModels::ForFields
          for_field :enum_field do |name:, presenter_class:|
            presenter_class.add_presenter name
          end
        end
      end
    end
  end
end
