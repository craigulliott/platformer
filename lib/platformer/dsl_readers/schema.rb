module Platformer
  module DSLReaders
    warn "not tested"
    class Schema
      class BaseClassCanNotBeNilError < StandardError
      end

      class UnexpectedBaseClassError < StandardError
      end

      def initialize base_class
        if base_class.nil?
          raise BaseClassCanNotBeNilError, "base_class is required"
        end
        unless base_class < BaseSchema
          raise BaseClassCanNotBeNilError, "base_class shoud extend from BaseSchema"
        end

        @base_class = base_class
      end

      def has_field? field_name
        fields.include? field_name
      end

      def fields
        executions_of_fields.map(&:arguments).map(&:fields).flatten.uniq
      end

      def root_node?
        !last_execution_of_root_node.nil?
      end

      def root_collection?
        !last_execution_of_root_collection.nil?
      end

      private

      def executions_of_fields
        @fields_reader ||= DSLCompose::Reader.new(@base_class, :fields).executions
      end

      def last_execution_of_root_node
        @root_node_reader ||= DSLCompose::Reader.new(@base_class, :root_node).last_execution
      end

      def last_execution_of_root_collection
        @root_collection_reader ||= DSLCompose::Reader.new(@base_class, :root_collection).last_execution
      end
    end
  end
end
