# frozen_string_literal: true

module Platformer
  module Constants
    module ISO
      class LanguageCode < Constant
        set_values ISO_639::ISO_639_1.map { |lang| lang.alpha2 }.freeze

        set_description <<~DESCRIPTION
          The complete list of two-letter language codes as per ISO 639-1 alpha-2
        DESCRIPTION
      end
    end
  end
end
