# frozen_string_literal: true

# this code is based on activerecord/lib/active_record/readonly_attributes.rb

module Platformer
  module ActiveRecord
    module Coercions
      module LowercaseCoercions
        extend ActiveSupport::Concern

        included do
          class_attribute :_attr_lowercase_coercion, instance_accessor: false, default: []
        end

        module ClassMethods
          # Attributes listed as lowercase will be be coerced into their lowercase form
          # before attributes are written
          def attr_lowercase_coercion(*attributes)
            self._attr_lowercase_coercion |= attributes.map(&:to_s)

            include(HasLowercaseCoersions)
          end

          # Returns an array of all the attributes that have been specified as lowercase.
          def lowercase_coercion_attributes
            _attr_lowercase_coercion
          end

          def lowercase_coercion_attribute?(name)
            _attr_lowercase_coercion.include?(name)
          end
        end

        module HasLowercaseCoersions
          def write_attribute(attr_name, value)
            if self.class.lowercase_coercion_attribute?(attr_name.to_s)
              # array columns
              if value.is_a?(Array)
                value = value.map(&:downcase)

              # standard columns
              elsif !value.nil?
                value = value.to_s.downcase
              end
            end

            super
          end

          def _write_attribute(attr_name, value)
            if self.class.lowercase_coercion_attribute?(attr_name.to_s)
              # array columns
              if value.is_a?(Array)
                value = value.map(&:downcase)

              # standard columns
              elsif !value.nil?
                value = value.to_s.downcase
              end
            end

            super
          end
        end
      end
    end
  end
end
