# frozen_string_literal: true

# this code is based on activerecord/lib/active_record/readonly_attributes.rb

module Platformer
  module ActiveRecord
    module Coercions
      module ZeroToNullCoercions
        extend ActiveSupport::Concern

        included do
          class_attribute :_attr_zero_to_null_coercion, instance_accessor: false, default: []
        end

        module ClassMethods
          # Attributes listed as zero_to_null will be be coerced into their zero_to_null form
          # before attributes are written
          def attr_zero_to_null_coercion(*attributes)
            self._attr_zero_to_null_coercion |= attributes.map(&:to_s)

            include(HasZeroToNullCoersions)
          end

          # Returns an array of all the attributes that have been specified as zero_to_null.
          def zero_to_null_coercion_attributes
            _attr_zero_to_null_coercion
          end

          def zero_to_null_coercion_attribute?(name)
            _attr_zero_to_null_coercion.include?(name)
          end
        end

        module HasZeroToNullCoersions
          def write_attribute(attr_name, value)
            if self.class.zero_to_null_coercion_attribute?(attr_name.to_s)
              # standard columns
              if value == 0
                value = nil

              # array columns
              elsif value.is_a?(Array)
                value = value.map { |v| (v == 0) ? nil : v }
              end
            end

            super
          end

          def _write_attribute(attr_name, value)
            if self.class.zero_to_null_coercion_attribute?(attr_name.to_s)
              # standard columns
              if value == 0
                value = nil

              # array columns
              elsif value.is_a?(Array)
                value = value.map { |v| (v == 0) ? nil : v }
              end
            end

            super
          end
        end
      end
    end
  end
end
