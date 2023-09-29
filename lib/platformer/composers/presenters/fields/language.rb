# frozen_string_literal: true

module Platformer
  module Composers
    module Presenters
      module Fields
        class Language < Parsers::FinalModels::ForFields
          for_field :language_field do |prefix:, presenter_class:|
            name_prepend = prefix.nil? ? "" : "#{prefix}_"

            column_name = :"#{name_prepend}language"

            presenter_class.add_presenter "#{name_prepend}language"

            presenter_class.add_presenter "#{name_prepend}language_code" do
              language = model.send(column_name)
              unless language.nil?
                Constants::ISO::Language.value_metadata(language, :code)
              end
            end

            presenter_class.add_presenter "#{name_prepend}language_alpha3_code" do
              language = model.send(column_name)
              unless language.nil?
                Constants::ISO::Language.value_metadata(language, :alpha3_code)
              end
            end

            presenter_class.add_presenter "#{name_prepend}language_english_name" do
              language = model.send(column_name)
              unless language.nil?
                Constants::ISO::Language.value_metadata(language, :name)
              end
            end
          end
        end
      end
    end
  end
end
