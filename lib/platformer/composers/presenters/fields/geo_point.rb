# frozen_string_literal: true

module Platformer
  module Composers
    module Presenters
      module Fields
        class GeoPoint < Parsers::Models::ForFields
          for_field :geo_point_field do |prefix:, presenter_class:|
            name_prepend = prefix.nil? ? "" : "#{prefix}_"
            column_name = "#{name_prepend}lonlat"

            presenter_class.add_presenter "#{name_prepend}longitude" do
              point_value = model.send(column_name)&.x
            end

            presenter_class.add_presenter "#{name_prepend}latitude" do
              point_value = model.send(column_name)&.y
            end
          end
        end
      end
    end
  end
end