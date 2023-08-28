# frozen_string_literal: true

module Platformer
  module Composers
    module ActiveRecord
      module Validations
        module Fields
          # install all the validations specifically designed for enum fields
          class Enum < Parsers::AllModels::ForFields
            for_field :enum_field do |name:, values:, active_record_class:, array:, default:, comment_text:, allow_null:|
              unless array
                description <<~DESCRIPTION
                  Create a validation on this active record model which asserts that
                  the value of `#{name}` is #{allow_null ? "null or " : ""} one of
                  the values '#{values.join("','")}'.
                DESCRIPTION
                # add the validation to the active record class
                active_record_class.validates name, inclusion: values, allow_nil: allow_null
              end
            end
          end
        end
      end
    end
  end
end
