# frozen_string_literal: true

module Platformer
  module Composers
    module Presenters
      module Associations
        class BelongsTo < Parsers::Models
          # todo: not tested
          for_dsl :belongs_to do |model:, module_name:, name:, presenter_class:|
            foreign_model_definition = model || "#{module_name}::#{name.to_s.classify}Model".constantize
            foreign_model_presenter_class = foreign_model_definition.presenter_class

            presenter_class.add_presenter name do |model, presenter|
              foreign_model = model.public_send name
              foreign_model.nil? ? nil : foreign_model_presenter_class.new(foreign_model)
            end
          end
        end
      end
    end
  end
end
