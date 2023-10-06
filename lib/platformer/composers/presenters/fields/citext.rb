# frozen_string_literal: true

module Platformer
  module Composers
    module Presenters
      module Fields
        class Citext < Parsers::Models::ForFields
          for_field :citext_field do |name:, presenter_class:|
            presenter_class.add_presenter name
          end
        end
      end
    end
  end
end
