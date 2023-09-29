# frozen_string_literal: true

module Platformer
  module Constants
    module ISO
      class Country < Constant
        # two letter country codes and metadata from the `Country` gem
        ISO3166::Country.all.each do |country|
          add_constant "COUNTRY_#{country.alpha2}", {
            name: country.iso_short_name,
            full_name: country.iso_long_name,
            subregion: country.subregion,
            code: country.alpha2,
            alpha3_code: country.alpha3,
            continent: country.continent
          }
        end

        set_description <<~DESCRIPTION
          The complete list of two-letter country codes as per ISO 3166-1 alpha-2
        DESCRIPTION
      end
    end
  end
end
