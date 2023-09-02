# frozen_string_literal: true

module Platformer
  module Composers
    module Presenters
      module Fields
        class Currency < Parsers::FinalModels::ForFields
          for_field :currency_field do |prefix:, presenter_class:|
            name_prepend = prefix.nil? ? "" : "#{prefix}_"

            column_name = :"#{name_prepend}currency"

            presenter_class.add_presenter "#{name_prepend}currency_name" do
              currency_code = model.send(column_name)
              unless currency_code.nil?
                Money::Currency.new(currency_code)&.name
              end
            end

            presenter_class.add_presenter "#{name_prepend}currency_code" do
              currency_code = model.send(column_name)
              unless currency_code.nil?
                Money::Currency.new(currency_code)&.iso_code
              end
            end

            presenter_class.add_presenter "#{name_prepend}currency_symbol" do
              currency_code = model.send(column_name)
              unless currency_code.nil?
                Money::Currency.new(currency_code)&.symbol
              end
            end
          end
        end
      end
    end
  end
end
