# frozen_string_literal: true

module Platformer
  module Composers
    module Presenters
      module Associations
        class HasOne < Parsers::AllModels
          warn "not tested"
          for_dsl :has_one do |foreign_model:, as:, presenter_class:|
            association_name = as || foreign_model.active_record_class.name.split("::").last.underscore.to_sym
            foreign_model_presenter_class = foreign_model.presenter_class
            presenter_class.add_presenter association_name do
              foreign_model = model.public_send association_name
              foreign_model.nil? ? nil : foreign_model_presenter_class.new(foreign_model)
            end
          end
        end
      end
    end
  end
end
