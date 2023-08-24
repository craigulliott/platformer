# frozen_string_literal: true

# this code is based on activerecord/lib/active_record/readonly_attributes.rb

module Platformer
  module ActiveRecord
    module Coercions
      module EmptyJsonToNullCoercions
        extend ActiveSupport::Concern

        included do
          class_attribute :_attr_empty_json_to_null_coercion, instance_accessor: false, default: []
        end

        module ClassMethods
          # Attributes listed as empty_json_to_null will be be coerced into their empty_json_to_null form
          # before attributes are written
          def attr_empty_json_to_null_coercion(*attributes)
            self._attr_empty_json_to_null_coercion |= attributes.map(&:to_s)

            include(HasEmptyJsonToNullCoersions)
          end

          # Returns an json of all the attributes that have been specified as empty_json_to_null.
          def empty_json_to_null_coercion_attributes
            _attr_empty_json_to_null_coercion
          end

          def empty_json_to_null_coercion_attribute?(name)
            _attr_empty_json_to_null_coercion.include?(name)
          end
        end

        module HasEmptyJsonToNullCoersions
          def write_attribute(attr_name, value)
            if self.class.empty_json_to_null_coercion_attribute?(attr_name.to_s) && value.is_a?(Hash) && value.keys.count == 0
              value = nil
            end

            super
          end

          def _write_attribute(attr_name, value)
            if self.class.empty_json_to_null_coercion_attribute?(attr_name.to_s) && value.is_a?(Hash) && value.keys.count == 0
              value = nil
            end

            super
          end
        end
      end
    end
  end
end
