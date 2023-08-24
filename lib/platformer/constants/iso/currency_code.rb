# frozen_string_literal: true

module Platformer
  module Constants
    module ISO
      class CurrencyCode < Constant
        # three letter ISO 4217 currency codes from the `Money` gem
        set_values Money::Currency.table.map(&:first).map(&:to_s).map(&:upcase).uniq.freeze

        set_description <<~DESCRIPTION
          The complete list of three-letter currency codes as per ISO 4217
        DESCRIPTION
      end
    end
  end
end
