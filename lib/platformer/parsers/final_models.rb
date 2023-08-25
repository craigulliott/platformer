module Platformer
  module Parsers
    # Apply the parser to every 'final descendant' of PlatformModel—a final descendant
    # being a class that inherits from PlatformModel but is not further subclassed.
    # Classes identified by this strategy are those with their own data storage, while
    # omitted classes serve merely to share configurations among the classes that extend them.
    #
    # Crucially, classes returned by this parser are guaranteed to have a corresponding table
    # object, which reflects the structure of the database table supporting the model.
    class FinalModels < DSLCompose::Parser
      class ArgumentNotAvailableError < StandardError
      end

      # Create a convenience method which can be used in parsers which extend this one
      # and abstract away some common code.
      def self.for_dsl dsl_names, &block
        # Processes every ancestor of the PlatformModel class.
        for_final_children_of PlatformModel do |child_class:|
          # Yields the provided block and provides the requested values for
          # each use of the provided DSL
          for_dsl_or_inherited_dsl dsl_names do |dsl_name:, reader:, dsl_arguments:|
            # only keep the arguments which the block is trying to use
            final_args = {}
            desired_arg_names = block.parameters.map(&:last)
            desired_arg_names.each do |arg_name|
              # all the arguments which can be passed to the block
              case arg_name
              when :dsl_name
                final_args[:dsl_name] = dsl_name

              when :table
                # the table structure object from DynamicMigrations, this was created and
                # the result cached within the CreateStructure parser
                final_args[:table] = child_class.table_structure

              when :schema
                # the schema structure object from DynamicMigrations, this was created and
                # the result cached within the CreateStructure parser (via the table)
                final_args[:schema] = child_class.table_structure.schema

              when :reader
                final_args[:reader] = reader

              when :child_class
                final_args[:child_class] = child_class

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
