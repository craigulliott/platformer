# frozen_string_literal: true

module Platformer
  module Constants
    module ISO
      class Currency < Constant
        # three letter ISO 4217 currency codes and metadata from the `Money` gem
        # getting unique ISO codes because of the discrepency between GHC and GHS
        Money::Currency.table.map(&:last).map { |c| c[:iso_code] }.uniq.each do |currency_code|
          currency = Money::Currency.new(currency_code)

          add_constant "CURRENCY_#{currency.iso_code}", {
            name: currency.name,
            code: currency.iso_code,
            symbol: currency.symbol
          }
        end

        set_description <<~DESCRIPTION
          The complete list of three-letter currency codes as per ISO 4217
        DESCRIPTION
      end
    end
  end
end
