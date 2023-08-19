# frozen_string_literal: true

# this code is based on activerecord/lib/active_record/readonly_attributes.rb

module Platformer
  module ActiveRecord
    module Coercions
      module RemoveNullArrayValuesCoercions
        extend ActiveSupport::Concern

        included do
          class_attribute :_attr_remove_null_array_values_coercion, instance_accessor: false, default: []
        end

        module ClassMethods
          # Attributes listed as remove_null_array_values will be be coerced into their remove_null_array_values form
          # before attributes are written
          def attr_remove_null_array_values_coercion(*attributes)
            self._attr_remove_null_array_values_coercion |= attributes.map(&:to_s)

            include(HasRemoveNullArrayValuesCoersions)
          end

          # Returns an array of all the attributes that have been specified as remove_null_array_values.
          def remove_null_array_values_coercion_attributes
            _attr_remove_null_array_values_coercion
          end

          def remove_null_array_values_coercion_attribute?(name)
            _attr_remove_null_array_values_coercion.include?(name)
          end
        end

        module HasRemoveNullArrayValuesCoersions
          def write_attribute(attr_name, value)
            if self.class.remove_null_array_values_coercion_attribute?(attr_name.to_s) && value.is_a?(Array)
              value = value.filter { |v| !v.nil? }
            end

            super
          end

          def _write_attribute(attr_name, value)
            if self.class.remove_null_array_values_coercion_attribute?(attr_name.to_s) && value.is_a?(Array)
              value = value.filter { |v| !v.nil? }
            end

            super
          end
        end
      end
    end
  end
end
