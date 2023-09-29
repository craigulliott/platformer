# frozen_string_literal: true

module Platformer
  module Composers
    module ActiveRecord
      module Validations
        module Common
          # Install a presence validation for all fields which are not allow_null for each model
          class NotNull < Parsers::AllModels::ForFields
            for_all_fields do |column_names:, reader:, active_record_class:, allow_null:|
              unless allow_null
                add_documentation <<~DESCRIPTION
                  Create a validation on this active record model which asserts that
                  the value of `#{column_names.to_sentence}` is not NULL.
                DESCRIPTION

                column_names.each do |column_name|
                  # add the validation to the active record class
                  active_record_class.validates column_name, {
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
end
