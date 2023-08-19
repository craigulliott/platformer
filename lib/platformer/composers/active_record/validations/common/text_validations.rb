# frozen_string_literal: true

module Platformer
  module Composers
    module ActiveRecord
      module Validations
        module Common
          class TextValidations < DSLCompose::Parser
            # Process the parser for every decendant of PlatformModel. This includes Models
            # which might be in the class hieracy for a model, but could be abstract and may
            # not have their own coresponding table within the database
            for_children_of PlatformModel do |child_class:|
              model = ClassMap.get_active_record_class_from_model_class(child_class)

              for_dsl [:integer_field, :float_field, :double_field, :numeric_field] do |name:|
              end
            end
          end
        end
      end
    end
  end
end
