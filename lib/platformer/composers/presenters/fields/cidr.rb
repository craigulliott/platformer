# frozen_string_literal: true

module Platformer
  module Composers
    module Presenters
      module Fields
        class Cidr < Parsers::FinalModels::ForFields
          for_field :cidr_field do |name:, presenter_class:|
            presenter_class.add_presenter name
          end
        end
      end
    end
  end
end
