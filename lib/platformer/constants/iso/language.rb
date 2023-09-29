# frozen_string_literal: true

module Platformer
  module Constants
    module ISO
      class Language < Constant
        ISO_639::ISO_639_1.map { |lang| lang.alpha2 }.each do |language_code|
          add_constant "LANG_#{language_code.upcase}", {
            name: ISO_639.find(language_code).english_name,
            code: language_code,
            alpha3_code: ISO_639.find(language_code).alpha3
          }
        end

        set_description <<~DESCRIPTION
          The complete list of two-letter language codes as per ISO 639-1 alpha-2
        DESCRIPTION
      end
    end
  end
end
