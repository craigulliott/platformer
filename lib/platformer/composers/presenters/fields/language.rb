# frozen_string_literal: true

module Platformer
  module Composers
    module Presenters
      module Fields
        class Language < Parsers::FinalModels::ForFields
          for_field :language_field do |prefix:, presenter_class:|
            name_prepend = prefix.nil? ? "" : "#{prefix}_"

            column_name = :"#{name_prepend}language"

            presenter_class.add_presenter "#{name_prepend}language_alpha2" do
              language_code = model.send(column_name)
              unless language_code.nil?
                ISO_639.find(language_code)&.alpha2
              end
            end

            presenter_class.add_presenter "#{name_prepend}language_alpha3" do
              language_code = model.send(column_name)
              unless language_code.nil?
                ISO_639.find(language_code)&.alpha3
              end
            end

            presenter_class.add_presenter "#{name_prepend}language_english_name" do
              language_code = model.send(column_name)
              unless language_code.nil?
                ISO_639.find(language_code)&.english_name
              end
            end
          end
        end
      end
    end
  end
end
