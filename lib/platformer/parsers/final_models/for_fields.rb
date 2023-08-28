module Platformer
  module Parsers
    # A convenience wrapper for the FinalModels parser which simplifies
    # parsing field DSLs
    class FinalModels
      class ForFields < FinalModels
        class ArgumentNotAvailableError < StandardError
        end

        include ForFieldMacros

        def self.for_fields field_names, &block
          for_dsl field_names do |model_class:, dsl_name:, reader:, name:, dsl_arguments:|
            # only provide the arguments which the block is trying to use
            final_args = {}
            desired_arg_names = block.parameters.map(&:last)
            desired_arg_names.each do |arg_name|
              # all the arguments which can be passed to the block
              case arg_name
              when :dsl_name
                final_args[:dsl_name] = dsl_name

              when :allow_null
                final_args[:allow_null] = method_called?(:allow_null)

              when :comment_text
                final_args[:comment_text] = reader.comment&.comment

              when :table
                # the table structure object from DynamicMigrations, this was created and
                # the result cached within the CreateStructure composer
                final_args[:table] = model_class.table_structure

              when :schema
                # the schema structure object from DynamicMigrations, this was created and
                # the result cached within the CreateStructure composer (via the table)
                final_args[:schema] = model_class.table_structure.schema

              when :database
                # the database configuratiom object
                final_args[:database] = model_class.configured_database

              when :model_class
                final_args[:model_class] = model_class

              when :schema_class
                # get the equivilent Schema definition class (based on naming conventions)
                # will raise an error if the desired Schema class does not exist
                final_args[:schema_class] = model_class.schema_class

              when :graphql_type_class
                # get the equivilent GraphQL Type class (based on naming conventions)
                # will raise an error if the desired Type class does not exist
                final_args[:graphql_type_class] = model_class.graphql_type_class

              when :active_record_class
                # get the equivilent ActiveRecord class (based on naming conventions)
                # will raise an error if the ActiveRecord class does not exist
                final_args[:active_record_class] = model_class.active_record_class

              when :column
                # Get the coresponding column object from DynamicMigrations for this field
                # column is not available until the first field composer runs, and builds it
                final_args[:column] = model_class.table_structure.column(name)

              when :reader
                final_args[:reader] = reader

              when :default
                final_args[:default] = reader.default&.default

              else
                if dsl_arguments.key? arg_name
                  final_args[arg_name] = dsl_arguments[arg_name]
                else
                  raise ArgumentNotAvailableError, "Can not find an equivilent argument for name `#{arg_name}`"
                end
              end
            end
            # yield the block with the expected arguments
            instance_exec(**final_args, &block)
          end
        end
      end
    end
  end
end
