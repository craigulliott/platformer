module Platformer
  module Parsers
    # Process the parser for every descendant of BaseSchema.
    class Schemas < DSLCompose::Parser
      class ArgumentNotAvailableError < StandardError
      end

      # yields the provided block for all final schemas
      def self.for_final_schemas &block
        # Processes every ancestor of the BaseSchema class.
        for_final_children_of BaseSchema do |child_class:|
          # only provide the arguments which the block is trying to use
          final_args = {}
          desired_arg_names = block.parameters.map(&:last)
          desired_arg_names.each do |arg_name|
            # all the arguments which can be passed to the block
            case arg_name
            when :schema_class
              final_args[:schema_class] = child_class

            when :schema_reader
              final_args[:schema_reader] = DSLReaders::Schema.new(child_class)

            when :graphql_type_class
              final_args[:graphql_type_class] = child_class.graphql_type_class

            when :model_class
              final_args[:model_class] = child_class.model_class

            when :active_record_class
              final_args[:active_record_class] = child_class.active_record_class

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

      # Create a convenience method which can be used in parsers which extend this one
      # and abstract away some common code.
      def self.for_dsl dsl_names, &block
        # Processes every ancestor of the BaseSchema class.
        for_final_schemas do |schema_class:|
          # Yields the provided block and provides the requested values for
          # each use of the provided DSL on the current model class (not any
          # of its ancestors)
          for_dsl dsl_names do |dsl_name:, reader:, dsl_arguments:|
            # only provide the arguments which the block is trying to use
            final_args = {}
            desired_arg_names = block.parameters.map(&:last)
            desired_arg_names.each do |arg_name|
              # all the arguments which can be passed to the block
              case arg_name
              when :dsl_name
                final_args[:dsl_name] = dsl_name

              when :schema_class
                final_args[:schema_class] = schema_class

              when :schema_reader
                final_args[:schema_reader] = DSLReaders::Schema.new(schema_class)

              when :graphql_type_class
                # get the equivilent GraphQL Type class (based on naming conventions)
                # will raise an error if the desired Type class does not exist
                final_args[:graphql_type_class] = schema_class.graphql_type_class

              when :model_class
                # get the equivilent Model definition class (based on naming conventions)
                # will raise an error if the desired Model class does not exist
                final_args[:model_class] = schema_class.model_class

              when :active_record_class
                # get the equivilent ActiveRecord class (based on naming conventions)
                # will raise an error if the ActiveRecord class does not exist
                final_args[:active_record_class] = schema_class.active_record_class

              when :reader
                final_args[:reader] = reader

              when :dsl_arguments
                final_args[:dsl_arguments] = dsl_arguments

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
