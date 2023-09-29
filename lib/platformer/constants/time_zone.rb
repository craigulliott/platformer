# frozen_string_literal: true

module Platformer
  module Constants
    class TimeZone < Constant
      ActiveSupport::TimeZone.all.uniq { |tz| tz.tzinfo.identifier }.sort.map do |tz|
        # skip this one
        next if tz.tzinfo.identifier == "Etc/GMT+12"

        symbol = tz.tzinfo.identifier.gsub(/[^_a-zA-Z0-9]/, "_").squeeze("_").upcase!

        symbol = "UTC" if symbol == "ETC_UTC"

        add_constant "TZ_#{symbol}", {
          name: tz.name,
          identifier: tz.tzinfo.identifier
        }
      end

      set_description <<~DESCRIPTION
        The complete list of time zones as per the TimeZone class in ActiveSupport
      DESCRIPTION
    end
  end
end
