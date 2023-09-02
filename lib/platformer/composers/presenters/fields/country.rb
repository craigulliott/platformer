# frozen_string_literal: true

module Platformer
  module Composers
    module Presenters
      module Fields
        class Country < Parsers::FinalModels::ForFields
          for_field :country_field do |prefix:, presenter_class:|
            name_prepend = prefix.nil? ? "" : "#{prefix}_"

            column_name = :"#{name_prepend}country"

            presenter_class.add_presenter "#{name_prepend}country_name" do
              country_code = model.send(column_name)
              unless country_code.nil?
                ISO3166::Country.new(country_code)&.iso_short_name
              end
            end

            presenter_class.add_presenter "#{name_prepend}country_full_name" do
              country_code = model.send(column_name)
              unless country_code.nil?
                ISO3166::Country.new(country_code)&.iso_long_name
              end
            end

            presenter_class.add_presenter "#{name_prepend}country_subregion" do
              country_code = model.send(column_name)
              unless country_code.nil?
                ISO3166::Country.new(country_code)&.subregion
              end
            end

            presenter_class.add_presenter "#{name_prepend}country_alpha2" do
              country_code = model.send(column_name)
              unless country_code.nil?
                ISO3166::Country.new(country_code)&.alpha2
              end
            end

            presenter_class.add_presenter "#{name_prepend}country_alpha3" do
              country_code = model.send(column_name)
              unless country_code.nil?
                ISO3166::Country.new(country_code)&.alpha3
              end
            end

            presenter_class.add_presenter "#{name_prepend}country_continent" do
              country_code = model.send(column_name)
              unless country_code.nil?
                ISO3166::Country.new(country_code)&.continent
              end
            end
          end
        end
      end
    end
  end
end
