module Platformer
  module DSLReaders
    # todo: not tested
    class API
      class BaseClassCanNotBeNilError < StandardError
      end

      class UnexpectedBaseClassError < StandardError
      end

      def initialize base_class
        if base_class.nil?
          raise BaseClassCanNotBeNilError, "base_class is required"
        end
        unless base_class < BaseAPI
          raise BaseClassCanNotBeNilError, "base_class shoud extend from BaseAPI"
        end

        @base_class = base_class
      end

      def has_field? field_name
        fields.include? field_name
      end

      def fields
        executions_of_fields.map(&:arguments).map(&:fields).flatten.uniq
      end

      def get?
        !last_execution_of_get.nil?
      end

      def index?
        !last_execution_of_index.nil?
      end

      def create?
        !last_execution_of_create.nil?
      end

      def update?
        !last_execution_of_update.nil?
      end

      def delete?
        !last_execution_of_delete.nil?
      end

      def undelete?
        !last_execution_of_delete&.arguments&.undelete.nil?
      end

      private

      def executions_of_fields
        @fields_reader ||= DSLCompose::Reader.new(@base_class, :fields).executions
      end

      def last_execution_of_get
        @get_reader ||= DSLCompose::Reader.new(@base_class, :get).last_execution
      end

      def last_execution_of_index
        @index_reader ||= DSLCompose::Reader.new(@base_class, :index).last_execution
      end

      def last_execution_of_create
        @create_reader ||= DSLCompose::Reader.new(@base_class, :create).last_execution
      end

      def last_execution_of_update
        @update_reader ||= DSLCompose::Reader.new(@base_class, :update).last_execution
      end

      def last_execution_of_delete
        @delete_reader ||= DSLCompose::Reader.new(@base_class, :delete).last_execution
      end
    end
  end
end
