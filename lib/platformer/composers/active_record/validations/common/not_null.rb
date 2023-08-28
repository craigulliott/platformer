# frozen_string_literal: true

module Platformer
  module Composers
    module ActiveRecord
      module Validations
        module Common
          # Install a presence validation for all fields which are not allow_null for each model
          class NotNull < Parsers::AllModels::ForFields
            for_all_fields except: :phone_number do |name:, active_record_class:, allow_null:|
              unless allow_null
                description <<~DESCRIPTION
                  Create a validation on this active record model which asserts that
                  the value of `#{name}` is not NULL.
                DESCRIPTION

                # add the validation to the active record class
                active_record_class.validates name, {
                  not_nil: true
                }
              end
            end
          end
        end
      end
    end
  end
end
