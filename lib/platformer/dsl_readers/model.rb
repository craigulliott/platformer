module Platformer
  module DSLReaders
    warn "not tested"
    class Model
      class BaseClassCanNotBeNilError < StandardError
      end

      class UnexpectedBaseClassError < StandardError
      end

      def initialize base_class
        if base_class.nil?
          raise BaseClassCanNotBeNilError, "base_class is required"
        end
        unless base_class < BaseModel
          raise BaseClassCanNotBeNilError, "base_class shoud extend from BaseModel"
        end
        @base_class = base_class
      end

      def suppress_namespace?
        !last_execution_of_suppress_namespace.nil?
      end

      def public_name
        suppress_namespace? ? public_name_without_namespace : public_name_with_namespace
      end

      private

      def public_name_with_namespace
        @base_class.name.underscore.gsub("/", "__").gsub(/_model\Z/, "")
      end

      def public_name_without_namespace
        @base_class.name.split("::", 2).last.underscore.gsub("/", "__").gsub(/_model\Z/, "")
      end

      def last_execution_of_suppress_namespace
        @suppress_namespace_reader ||= DSLCompose::Reader.new(@base_class, :suppress_namespace).last_execution
      end
    end
  end
end
