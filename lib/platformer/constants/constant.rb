# frozen_string_literal: true

module Platformer
  module Constants
    class Constant
      def self.set_values values
        @values = values
      end

      def self.values
        @values
      end

      def self.set_description desc
        @description = desc
      end

      def self.description
        @description
      end

      def self.constant_name
        name.split("Platformer::Constants::").last.gsub("::", "_").underscore.to_sym
      end
    end
  end
end
