module Platformer
  module DSLReaders
    module Models
      class Database < DSLCompose::ReaderBase
        def server_type
          last_execution!.arguments.server_type
        end

        def server_name
          last_execution!.arguments.server_name
        end

        def database_name
          last_execution!.arguments.database_name
        end

        def has_database_name?
          last_execution!.arguments.database_name != nil
        end

        def schema_name
          last_execution_of_schema&.arguments&.schema_name || :public
        end

        private

        def last_execution_of_schema
          @schema_reader ||= DSLCompose::Reader.new(@base_class, :schema).last_execution
        end
      end
    end
  end
end
