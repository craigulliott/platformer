# frozen_string_literal: true

module Platformer
  module Constants
    module ISO
      class CountryCode < Constant
        # two letter country codes from the `Country` gem
        set_values ISO3166::Country.codes.dup.freeze

        set_description <<~DESCRIPTION
          The complete list of two-letter country codes as per ISO 3166-1 alpha-2
        DESCRIPTION
      end
    end
  end
end
