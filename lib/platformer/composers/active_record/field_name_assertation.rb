# frozen_string_literal: true

module Platformer
  module Composers
    module ActiveRecord
      # install all the validations specifically designed for boolean fields
      class FieldNameAssertation < Parsers::AllModels::ForFields
        class ReservedAttributeNameError < StandardError
        end

        for_all_fields do |column_names:, active_record_class:|
          column_names.each do |column_name|
            if active_record_class.instance_methods.include? column_name
              raise ReservedAttributeNameError, "The field name `#{column_name}` is reserved. An instance method of the same name already exists on this #{active_record_class.name}"
            end
          end
        end
      end
    end
  end
end
