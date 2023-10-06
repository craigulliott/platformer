# frozen_string_literal: true

module Platformer
  module Composers
    module Presenters
      module Fields
        class MacAddress < Parsers::Models::ForFields
          for_field :mac_address_field do |name:, presenter_class:|
            presenter_class.add_presenter name
          end
        end
      end
    end
  end
end
