module Platformer
  module Parsers
    # Apply the parser to every 'final descendant' of BaseModel—a final descendant
    # being a class that inherits from BaseModel but is not further subclassed.
    # Classes identified by this strategy are those with their own data storage, while
    # omitted classes serve merely to share configurations among the classes that extend them.
    #
    # Crucially, classes returned by this parser are guaranteed to have a corresponding table
    # object, which reflects the structure of the database table supporting the model.
    class FinalModels < DSLCompose::Parser
      class ArgumentNotAvailableError < StandardError
      end

      # yields the provided block for all final models
      def self.for_final_models &block
        # Processes every ancestor of the BaseModel class.
        for_final_children_of BaseModel do |child_class:|
          # yield the block with the expected arguments
          instance_exec(model_definition_class: child_class, &block)
        end
      end

      # yields the provided block for all final models which use the provided DSL
      # on the model class or one of it's ancestors
      def self.for_dsl dsl_names, &block
        # remember the parser name (class name), so we can present more useful errors
        parser_name = name

        # Processes every ancestor of the BaseModel class.
        for_final_models do |model_definition_class:|
          # Yields the provided block and provides the requested values for
          # each use of the provided DSL
          for_dsl_or_inherited_dsl dsl_names do |dsl_name:, reader:, dsl_arguments:|
            # only provide the arguments which the block is trying to use
            desired_arg_names = block.parameters.map(&:last)

            # try and resolve the list of requested arguments via a helper which
            # processess the most common arguments
            final_args = ClassSwitchArgumentsHelper.resolve_arguments desired_arg_names, model_definition_class

            # try and resolve the rest of the requested arguments
            desired_arg_names.each do |arg_name|
              # all the arguments which can be passed to the block
              case arg_name
              when :dsl_name
                final_args[:dsl_name] = dsl_name

              when :table
                # the table structure object from DynamicMigrations, this was created and
                # the result cached within the CreateStructure composer
                final_args[:table] = model_definition_class.table_structure

              when :schema
                # the schema structure object from DynamicMigrations, this was created and
                # the result cached within the CreateStructure composer (via the table)
                final_args[:schema] = model_definition_class.table_structure.schema

              when :reader
                final_args[:reader] = reader

              when :dsl_arguments
                final_args[:dsl_arguments] = dsl_arguments

              else
                # if the argument exists within the dsl's arguments, then
                # resolve it automatically to that value
                if dsl_arguments.key? arg_name
                  final_args[arg_name] = dsl_arguments[arg_name]

                # otherwise, if it wasnt already set by the common args helper, then raise an error
                elsif !final_args.key? arg_name
                  raise ArgumentNotAvailableError, arg_name
                end
              end
            rescue ArgumentNotAvailableError
              raise ArgumentNotAvailableError, "Can not find an equivilent argument for name `#{$!}` while parsing DSL `#{dsl_name}` within composer `#{parser_name}`"
            rescue
              raise $!, "Error for DSL `#{dsl_name}` within composer `#{parser_name}`: Original Error Message: #{$!}", $!.backtrace
            end
            # yield the block with the expected arguments
            instance_exec(**final_args, &block)
          end
        end
      end
    end
  end
end
