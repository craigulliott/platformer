module Platformer
  module DSLReaders
    warn "not tested"
    class Schema
      def initialize base_class
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

      def suppress_namespace?
        !last_execution_of_suppress_namespace.nil?
      end

      def public_name
        suppress_namespace? ? public_name_without_namespace : public_name_with_namespace
      end

      private

      def public_name_with_namespace
        @base_class.name.underscore.gsub("/", "__").gsub(/_schema\Z/, "")
      end

      def public_name_without_namespace
        @base_class.name.split("::", 2).last.underscore.gsub("/", "__").gsub(/_schema\Z/, "")
      end

      def executions_of_fields
        @fields_reader ||= DSLCompose::Reader.new(@base_class, :fields).executions
      end

      def last_execution_of_root_node
        @root_node_reader ||= DSLCompose::Reader.new(@base_class, :root_node).last_execution
      end

      def last_execution_of_root_collection
        @root_collection_reader ||= DSLCompose::Reader.new(@base_class, :root_collection).last_execution
      end

      def last_execution_of_suppress_namespace
        @suppress_namespace_reader ||= DSLCompose::Reader.new(@base_class, :suppress_namespace).last_execution
      end
    end
  end
end
