# frozen_string_literal: true

# this code is based on activerecord/lib/active_record/readonly_attributes.rb

module Platformer
  module ActiveRecord
    module Coercions
      module UppercaseCoercions
        extend ActiveSupport::Concern

        included do
          class_attribute :_attr_uppercase_coercion, instance_accessor: false, default: []
        end

        module ClassMethods
          # Attributes listed as uppercase will be be coerced into their uppercase form
          # before attributes are written
          def attr_uppercase_coercion(*attributes)
            self._attr_uppercase_coercion |= attributes.map(&:to_s)

            include(HasUppercaseCoersions)
          end

          # Returns an array of all the attributes that have been specified as uppercase.
          def uppercase_coercion_attributes
            _attr_uppercase_coercion
          end

          def uppercase_coercion_attribute?(name)
            _attr_uppercase_coercion.include?(name)
          end
        end

        module HasUppercaseCoersions
          def write_attribute(attr_name, value)
            if self.class.uppercase_coercion_attribute?(attr_name.to_s) && !value.nil?
              value = value.to_s.upcase
            end

            super
          end

          def _write_attribute(attr_name, value)
            if self.class.uppercase_coercion_attribute?(attr_name.to_s) && !value.nil?
              value = value.to_s.upcase
            end

            super
          end
        end
      end
    end
  end
end
