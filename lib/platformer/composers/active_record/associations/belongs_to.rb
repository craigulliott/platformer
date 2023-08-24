# frozen_string_literal: true

module Platformer
  module Composers
    module ActiveRecord
      module Associations
        class BelongsTo < DSLCompose::Parser
          # Process the parser for every decendant of PlatformModel. This includes Models
          # which might be in the class hieracy for a model, but could be abstract and may
          # not have their own coresponding table within the database
          for_children_of PlatformModel do |child_class:|
            # for each time the provided fields DSL was used on this Model
            for_dsl_or_inherited_dsl :belongs_to do |foreign_model:, local_column_names:, foreign_column_names:|
              model = child_class.active_record_class

              if local_column_names.any? || foreign_column_names.any?
                raise "not currently supported"
              end

              association_name = foreign_model.active_record_class.name.split("::").last.underscore.to_sym
              model.belongs_to association_name, class_name: foreign_model.active_record_class.name
            end
          end
        end
      end
    end
  end
end
