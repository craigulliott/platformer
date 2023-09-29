# frozen_string_literal: true

module Platformer
  module Constants
    class Constant
      class ValueDoesNotExistError < StandardError
      end

      class MetadataKeyDoesNotExistError < StandardError
      end

      class ValueAlreadyExistsError < StandardError
      end

      class ValueShouldBeStringError < StandardError
      end

      class InvalidFormatError < StandardError
      end

      def self.add_constant value, metadata = {}
        @values ||= {}

        unless value.is_a? String
          raise ValueShouldBeStringError, "Expecting string value, but got `#{value}` (#{value.class})"
        end

        if @values.key? value
          raise ValueAlreadyExistsError, "Value `#{value}` already exists"
        end

        unless value.match?(/\A[A-Z][A-Z0-9]*(_[A-Z0-9]+)*\z/)
          raise InvalidFormatError, "Value `#{value}` is invalid format for a constant, should be uppercase, start with a letter and can contain underscores"
        end

        @values[value.freeze] = metadata.freeze
      end

      def self.values
        @values.keys
      end

      def self.value_metadata value, key
        unless (metadata = @values[value])
          raise ValueDoesNotExistError, "Value `#{value}` does not exist"
        end

        unless metadata.key? key
          raise MetadataKeyDoesNotExistError, "Value `#{value}` does not have metadata for key `#{key}`"
        end

        metadata[key]
      end

      def self.set_description desc
        @description = desc
      end

      def self.description
        @description
      end

      def self.has_value? value
        @values&.key? value
      end

      def self.constant_name
        name.split("Platformer::Constants::").last.gsub("::", "_").underscore.to_sym
      end
    end
  end
end
