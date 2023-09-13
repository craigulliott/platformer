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

      def action_field_action action_field_name
        action_field_executions.first&.arguments&.action_name
      end

      def description
        last_execution_of_description&.arguments&.description
      end

      private

      def public_name_with_namespace
        @base_class.name.underscore.gsub("/", "__").gsub(/_model\Z/, "")
      end

      def public_name_without_namespace
        @base_class.name.split("::", 2).last.underscore.gsub("/", "__").gsub(/_model\Z/, "")
      end

      def last_execution_of_description
        @description_reader ||= DSLCompose::Reader.new(@base_class, :description).last_execution
      end

      def last_execution_of_suppress_namespace
        @suppress_namespace_reader ||= DSLCompose::Reader.new(@base_class, :suppress_namespace).last_execution
      end

      def action_field_executions
        @action_field_executions ||= DSLCompose::Reader.new(@base_class, :action_field).executions
      end
    end
  end
end
