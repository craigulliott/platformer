# frozen_string_literal: true

module Platformer
  module Composers
    module Presenters
      module Fields
        class Country < Parsers::Models::ForFields
          for_field :country_field do |prefix:, presenter_class:|
            name_prepend = prefix.nil? ? "" : "#{prefix}_"

            column_name = :"#{name_prepend}country"

            presenter_class.add_presenter "#{name_prepend}country"

            presenter_class.add_presenter "#{name_prepend}country_code" do |model, presenter|
              country_enum = model.public_send(column_name)
              unless country_enum.nil?
                Constants::ISO::Country.value_metadata(country_enum, :code)
              end
            end

            presenter_class.add_presenter "#{name_prepend}country_alpha3_code" do |model, presenter|
              country_enum = model.public_send(column_name)
              unless country_enum.nil?
                Constants::ISO::Country.value_metadata(country_enum, :alpha3_code)
              end
            end

            presenter_class.add_presenter "#{name_prepend}country_name" do |model, presenter|
              country_enum = model.public_send(column_name)
              unless country_enum.nil?
                Constants::ISO::Country.value_metadata(country_enum, :name)
              end
            end

            presenter_class.add_presenter "#{name_prepend}country_full_name" do |model, presenter|
              country_enum = model.public_send(column_name)
              unless country_enum.nil?
                Constants::ISO::Country.value_metadata(country_enum, :full_name)
              end
            end

            presenter_class.add_presenter "#{name_prepend}country_subregion" do |model, presenter|
              country_enum = model.public_send(column_name)
              unless country_enum.nil?
                Constants::ISO::Country.value_metadata(country_enum, :subregion)
              end
            end

            presenter_class.add_presenter "#{name_prepend}country_continent" do |model, presenter|
              country_enum = model.public_send(column_name)
              unless country_enum.nil?
                Constants::ISO::Country.value_metadata(country_enum, :continent)
              end
            end
          end
        end
      end
    end
  end
end
