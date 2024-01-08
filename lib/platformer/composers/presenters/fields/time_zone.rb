# frozen_string_literal: true

module Platformer
  module Composers
    module Presenters
      module Fields
        class TimeZone < Parsers::Models::ForFields
          for_field :time_zone_field do |prefix:, presenter_class:|
            name_prepend = prefix.nil? ? "" : "#{prefix}_"

            column_name = :"#{name_prepend}time_zone"

            presenter_class.add_presenter "#{name_prepend}time_zone"

            presenter_class.add_presenter "#{name_prepend}time_zone_name" do |model, presenter|
              country_enum = model.public_send(column_name)
              unless country_enum.nil?
                Constants::TimeZone.value_metadata(country_enum, :name)
              end
            end

            presenter_class.add_presenter "#{name_prepend}time_zone_identifier" do |model, presenter|
              country_enum = model.public_send(column_name)
              unless country_enum.nil?
                Constants::TimeZone.value_metadata(country_enum, :identifier)
              end
            end
          end
        end
      end
    end
  end
end
