# frozen_string_literal: true

module Platformer
  module Constants
    module ISO
      class DialingCode < Constant
        # complete list of dialing codes courtesy of the `Country` gem
        set_values ISO3166::Country.all.map { |c| c.country_code }.select { |c| c.present? }.uniq.sort.freeze

        set_description <<~DESCRIPTION
          The complete list of international dialing codes.
        DESCRIPTION
      end
    end
  end
end
