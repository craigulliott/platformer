# frozen_string_literal: true

module Platformer
  module Composers
    module ActiveRecord
      module Coercions
        module Fields
          class Json < Parsers::AllModels::ForFields
            # install all the empty_json_to_null coercions for each model
            for_field :json_field do |name:, model:, allow_null:|
              for_method :empty_json_to_null do
                description <<~DESCRIPTION
                  Create a before_validation callback on this active_record class which
                  will convert empty objects in the `#{name}` field into null. This logic
                  is also injected into ActiveRecord and overrides the write_attribute method,
                  this will ensure that the coercion happens even if callbacks are skipped.
                DESCRIPTION

                # add the before_validation callback to the active record class
                model.before_validation do
                  value = send(name)
                  if value.is_a?(Hash) && value.keys.count == 0
                    send "#{name}=", nil
                  end
                end

                # inject this into the class and override the write_attribute system
                model.attr_empty_json_to_null_coercion name
              end
            end
          end
        end
      end
    end
  end
end
