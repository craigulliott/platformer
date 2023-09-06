# frozen_string_literal: true

module Platformer
  module Composers
    module Presenters
      module Associations
        class HasMany < Parsers::AllModels
          warn "not tested"
          for_dsl :has_many do |foreign_model:, as:, presenter_class:|
            association_name = as&.to_s&.pluralize&.to_sym || foreign_model.active_record_class.name.split("::").last.underscore.pluralize.to_sym
            # note, this does not return presenter classes, because we need to be able to
            # perform filtering and pagination on the result
            presenter_class.add_presenter association_name
          end
        end
      end
    end
  end
end
