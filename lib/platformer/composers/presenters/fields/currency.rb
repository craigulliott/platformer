# frozen_string_literal: true

module Platformer
  module Composers
    module Presenters
      module Fields
        class Currency < Parsers::Models::ForFields
          for_field :currency_field do |prefix:, presenter_class:|
            name_prepend = prefix.nil? ? "" : "#{prefix}_"

            column_name = :"#{name_prepend}currency"

            presenter_class.add_presenter "#{name_prepend}currency"

            presenter_class.add_presenter "#{name_prepend}currency_name" do
              currency = model.send(column_name)
              unless currency.nil?
                Constants::ISO::Currency.value_metadata(currency, :name)
              end
            end

            presenter_class.add_presenter "#{name_prepend}currency_code" do
              currency = model.send(column_name)
              unless currency.nil?
                Constants::ISO::Currency.value_metadata(currency, :code)
              end
            end

            presenter_class.add_presenter "#{name_prepend}currency_symbol" do
              currency = model.send(column_name)
              unless currency.nil?
                Constants::ISO::Currency.value_metadata(currency, :symbol)
              end
            end
          end
        end
      end
    end
  end
end
