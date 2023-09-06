module Platformer
  module Parsers
    # Apply the parser to every 'final descendant' of base_class—a final descendant
    # being a class that inherits from base_class but is not further subclassed.
    # Classes identified by this strategy are those with their own data storage, while
    # omitted classes serve merely to share configurations among the classes that extend them.
    #
    # Crucially, classes returned by this parser are guaranteed to have a corresponding table
    # object, which reflects the structure of the database table supporting the model.
    class ClassParser < DSLCompose::Parser
      class ArgumentNotAvailableError < StandardError
      end

      # allows child parsers (parsers which extend this class) to providing argument names and blocks
      # which can resolve parser specific arguments
      def self.resolve_argument argument_name, &block
        @argument_resolvers ||= {}
        @argument_resolvers[argument_name] = block
      end

      # Returns the argument resolver with the provided name for the current class, if
      # an argument is not found then we try this method on each classes direct ancestor
      # until we reach ClassParser.
      def self.argument_resolver argument_name
        ancestors.each do |parser_class|
          # process each child of this class, but stop once we get to this class
          break if parser_class == ClassParser
          arg_resolvers = parser_class.instance_variable_get(:@argument_resolvers)
          if arg_resolvers && arg_resolvers[argument_name]
            return arg_resolvers[argument_name]
          end
        end
      end

      def self.base_class base_class
        @base_class = base_class
      end

      def self.final_child_classes_only final_child_classes_only
        @final_child_classes_only = final_child_classes_only
      end

      def self.resolve_base_class
        # process each child of this class, but stop once we get to this class
        ancestors.each do |parser_class|
          break if parser_class == ClassParser
          if (base_class = parser_class.instance_variable_get(:@base_class))
            return base_class
          end
        end
      end

      def self.resolve_final_child_classes_only
        # process each child of this class, but stop once we get to this class
        ancestors.each do |parser_class|
          break if parser_class == ClassParser
          final_child_classes_only = parser_class.instance_variable_get(:@final_child_classes_only)
          unless final_child_classes_only.nil?
            return final_child_classes_only
          end
        end
      end

      # yields the provided block for all final classes for the provided base class
      # base_class should be something like BaseModel, BaseSchema or BaseMigration
      def self.for_base_class &block
        # remember the parser so we can pass to the ArgumentsResolver and get
        # more useful errors (the value of self would change once we enter the next block)
        parser_class = self

        base_class = resolve_base_class
        if base_class.nil?
          raise "base_class is nil, call `base_class YourBaseClass` in your child parser"
        end

        final_child_classes_only = resolve_final_child_classes_only
        if final_child_classes_only.nil?
          raise "final_child_classes_only is nil, call `final_child_classes_only true/false` in your child parser"
        end

        case final_child_classes_only
        when true
          # Processes every ancestor of the base_class class.
          for_final_children_of base_class do |child_class:|
            # resolve the list of arguments which this block is trying to use
            arguments_resolver = ArgumentsResolver.new child_class: child_class, parser_class: parser_class
            block_arguments = arguments_resolver.resolve_arguments_for_block(&block)

            # yield the block with the expected arguments
            instance_exec(**block_arguments, &block)
          end

        when false
          # Processes ancestors of the base_class class where those ancestors
          # are final classes (do not have any ancestors of their own).
          for_children_of base_class do |child_class:|
            # resolve the list of arguments which this block is trying to use
            arguments_resolver = ArgumentsResolver.new child_class: child_class, parser_class: parser_class
            block_arguments = arguments_resolver.resolve_arguments_for_block(&block)

            # yield the block with the expected arguments
            instance_exec(**block_arguments, &block)
          end
        end
      rescue
        raise $!, "Error within composer `#{name}`: Original Error Message: #{$!}", $!.backtrace
      end

      # yields the provided block for all final models which use the provided DSL
      # on the model class or one of it's ancestors
      def self.dsl_for_base_class dsl_names, &block
        # remember the parser so we can pass to the ArgumentsResolver and get
        # more useful errors (the value of self would change once we enter the next block)
        parser_class = self

        # Processes every ancestor of the base_class class.
        for_base_class do |child_class:|
          # Yields the provided block and provides the requested values for
          # each use of the provided DSL
          for_dsl_or_inherited_dsl dsl_names do |dsl_name:, reader:, dsl_arguments:, dsl_execution:|
            # resolve the list of arguments which this block is trying to use
            arguments_resolver = ArgumentsResolver.new child_class: child_class, parser_class: parser_class, dsl_name: dsl_name, reader: reader, dsl_arguments: dsl_arguments, dsl_execution: dsl_execution
            block_arguments = arguments_resolver.resolve_arguments_for_block(&block)

            # yield the block with the expected arguments
            instance_exec(**block_arguments, &block)
          rescue
            raise $!, "Error for DSL `#{dsl_name}` within composer `#{parser_class}`: Original Error Message: #{$!}", $!.backtrace
          end
        end
      end
    end
  end
end
