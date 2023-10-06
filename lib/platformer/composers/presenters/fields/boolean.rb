# frozen_string_literal: true

module Platformer
  module Composers
    module Presenters
      module Fields
        class Boolean < Parsers::Models::ForFields
          for_field :boolean_field do |name:, presenter_class:|
            presenter_class.add_presenter name
          end
        end
      end
    end
  end
end
