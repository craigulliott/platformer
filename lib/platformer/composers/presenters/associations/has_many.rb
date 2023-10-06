# frozen_string_literal: true

module Platformer
  module Composers
    module Presenters
      module Associations
        class HasMany < Parsers::Models
          warn "not tested"
          for_dsl :has_many do |model:, module_name:, name:, presenter_class:|
            association_name = name
            # note, this does not return presenter classes, because we need to be able to
            # perform filtering and pagination on the result
            presenter_class.add_presenter association_name
          end
        end
      end
    end
  end
end
