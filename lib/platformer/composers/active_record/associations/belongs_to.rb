# frozen_string_literal: true

module Platformer
  module Composers
    module ActiveRecord
      module Associations
        class BelongsTo < Parsers::AllModels
          for_dsl :belongs_to do |active_record_class:, foreign_model:, local_column_names:, foreign_column_names:|
            if local_column_names.any? || foreign_column_names.any?
              raise "not currently supported"
            end

            association_name = foreign_model.active_record_class.name.split("::").last.underscore.to_sym
            active_record_class.belongs_to association_name, class_name: foreign_model.active_record_class.name
          end
        end
      end
    end
  end
end
