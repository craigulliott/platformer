# frozen_string_literal: true

# this code is based on activerecord/lib/active_record/readonly_attributes.rb

module Platformer
  module ActiveRecord
    module Coercions
      module TrimAndNullifyCoercions
        extend ActiveSupport::Concern

        included do
          class_attribute :_attr_trim_and_nullify_coercion, instance_accessor: false, default: []
        end

        module ClassMethods
          # Attributes listed as trim_and_nullify will be be coerced into their trim_and_nullify form
          # before attributes are written
          def attr_trim_and_nullify_coercion(*attributes)
            self._attr_trim_and_nullify_coercion |= attributes.map(&:to_s)

            include(HasTrimAndNullifyCoersions)
          end

          # Returns an array of all the attributes that have been specified as trim_and_nullify.
          def trim_and_nullify_coercion_attributes
            _attr_trim_and_nullify_coercion
          end

          def trim_and_nullify_coercion_attribute?(name)
            _attr_trim_and_nullify_coercion.include?(name)
          end
        end

        module HasTrimAndNullifyCoersions
          def write_attribute(attr_name, value)
            if self.class.trim_and_nullify_coercion_attribute?(attr_name.to_s)
              # array columns
              if value.is_a?(Array)
                # strip whitespace from the front and back, and convert
                # empty strings to null
                value = value.map { |v| v.is_a?(String) ? v.strip : v }.map { |v| (v == "") ? nil : v }

              # standard columns (not arrays)
              elsif value.is_a? String
                value = value.strip
                value = nil if value == ""
              end
            end

            super
          end

          def _write_attribute(attr_name, value)
            if self.class.trim_and_nullify_coercion_attribute?(attr_name.to_s)
              # array columns
              if value.is_a?(Array)
                # strip whitespace from the front and back, and convert
                # empty strings to null
                value = value.map { |v| v.is_a?(String) ? v.strip : v }.map { |v| (v == "") ? nil : v }

              # standard columns (not arrays)
              elsif value.is_a? String
                value = value.strip
                value = nil if value == ""
              end
            end

            super
          end
        end
      end
    end
  end
end
