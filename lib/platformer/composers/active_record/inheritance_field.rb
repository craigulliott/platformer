# frozen_string_literal: true

module Platformer
  module Composers
    module ActiveRecord
      class InheritanceField < Parsers::Models::ForFields
        for_field :inheritance_field do |name:, active_record_class:|
          # set the inherritance_column on the active record class
          active_record_class.inheritance_column = name
        end
      end
    end
  end
end
