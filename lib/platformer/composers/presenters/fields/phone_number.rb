# frozen_string_literal: true

module Platformer
  module Composers
    module Presenters
      module Fields
        class PhoneNumber < Parsers::FinalModels::ForFields
          for_field :phone_number_field do |prefix:, presenter_class:|
            # only require this library if we have a phone number field
            require "phony"

            name_prepend = prefix.nil? ? "" : "#{prefix}_"

            dialing_code_method = :"#{name_prepend}dialing_code"
            phone_number_method = :"#{name_prepend}phone_number"

            presenter_class.add_presenter dialing_code_method
            presenter_class.add_presenter phone_number_method

            presenter_class.add_presenter "#{name_prepend}phone_number_formatted" do
              dialing_code = model.send(dialing_code_method)
              unless model.dialing_code.nil?
                phone_number = model.send(phone_number_method)
                Phony.format "#{dialing_code}#{phone_number}", format: :national
              end
            end

            presenter_class.add_presenter "#{name_prepend}phone_number_international_formatted" do
              dialing_code = model.send(dialing_code_method)
              unless model.dialing_code.nil?
                phone_number = model.send(phone_number_method)
                Phony.format "#{dialing_code}#{phone_number}", format: :international
              end
            end
          end
        end
      end
    end
  end
end

# full_number = Phony.normalize phone_number, cc: dialing_code
# Phony.format full_number, format: :national

# full_number = Phony.normalize phone_number, cc: dialing_code
# Phony.format full_number, format: :international
