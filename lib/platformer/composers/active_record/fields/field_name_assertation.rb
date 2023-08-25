# frozen_string_literal: true

module Platformer
  module Composers
    module ActiveRecord
      module Fields
        # install all the validations specifically designed for boolean fields
        class FieldNameAssertation < Parsers::AllModels::ForFields
          class ReservedAttributeNameError < StandardError
          end

          for_all_fields do |name:, model:|
            if model.instance_methods.include? name
              raise ReservedAttributeNameError, "The field name `#{name}` is reserved. An instance method of the same name already exists on this #{model.name}"
            end
          end
        end
      end
    end
  end
end
