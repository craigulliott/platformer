# frozen_string_literal: true

module Platformer
  module Constants
    module ISO
      class DialingCode < Constant
        # complete list of dialing codes and metadata courtesy of the `Country` gem
        ISO3166::Country.all.each do |country|
          value = "DIAL_CODE_#{country.country_code}"

          # because there are some duplicates in this gem
          next if has_value? value

          add_constant value, {
            name: "#{country.iso_short_name} (+#{country.country_code})",
            country_code: country.alpha2,
            country_name: country.iso_long_name,
            dialing_code: "+#{country.country_code}"
          }
        end

        set_description <<~DESCRIPTION
          The complete list of international dialing codes.
        DESCRIPTION
      end
    end
  end
end
