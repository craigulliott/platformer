# frozen_string_literal: true

# this code is based on activerecord/lib/active_record/readonly_attributes.rb

module Platformer
  module ActiveRecord
    module Coercions
      module EmptyArrayToNullCoercions
        extend ActiveSupport::Concern

        included do
          class_attribute :_attr_empty_array_to_null_coercion, instance_accessor: false, default: []
        end

        module ClassMethods
          # Attributes listed as empty_array_to_null will be be coerced into their empty_array_to_null form
          # before attributes are written
          def attr_empty_array_to_null_coercion(*attributes)
            self._attr_empty_array_to_null_coercion |= attributes.map(&:to_s)

            include(HasEmptyArrayToNullCoersions)
          end

          # Returns an array of all the attributes that have been specified as empty_array_to_null.
          def empty_array_to_null_coercion_attributes
            _attr_empty_array_to_null_coercion
          end

          def empty_array_to_null_coercion_attribute?(name)
            _attr_empty_array_to_null_coercion.include?(name)
          end
        end

        module HasEmptyArrayToNullCoersions
          def write_attribute(attr_name, value)
            if self.class.empty_array_to_null_coercion_attribute?(attr_name.to_s) && value.is_a?(Array) && value.empty?
              value = nil
            end

            super
          end

          def _write_attribute(attr_name, value)
            if self.class.empty_array_to_null_coercion_attribute?(attr_name.to_s) && value.is_a?(Array) && value.empty?
              value = nil
            end

            super
          end
        end
      end
    end
  end
end