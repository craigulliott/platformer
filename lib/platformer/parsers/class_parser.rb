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

      # Returns the argument resolver with the provided name for the current class
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

      # set the base class which the parser will orient off (will process decendent classes starting
      # at this point in the ancestor chain)
      def self.base_class base_class
        @base_class = base_class
      end

      # return the base_class which has been set above
      def self.resolve_base_class
        closest_value_of_instance_variable(:@base_class)
      end

      # set a boolean value which is used to determine if this parser processes all classes or only
      # final classes, final classes are classes which do not have any ancesrtors of their own (they
      # are at the end of the ancestor chain)
      def self.final_child_classes_only final_child_classes_only
        @final_child_classes_only = final_child_classes_only
      end

      # return the boolean value of final_child_classes_only has been set above
      def self.resolve_final_child_classes_only
        closest_value_of_instance_variable(:@final_child_classes_only)
      end

      # Called from the option getters above.
      # If requested instance variable not found then move down this parsers ancestor chain until we
      # find a value. This is because the class parser is designed to be extended to define more class
      # parsers, and we fall back to the most recently set option.
      def self.closest_value_of_instance_variable name
        # process each child of this class, but stop once we get to this class
        ancestors.each do |parser_class|
          break if parser_class == ClassParser
          value = parser_class.instance_variable_get(name)
          unless value.nil?
            return value
          end
        end
      end

      # set an array of class names (as strings) which is used to determine if this parser processes
      # should skip some classes
      def self.skip_classes class_names_to_skip
        # coerce a single class name into an array of class names
        class_names_to_skip = [class_names_to_skip] if class_names_to_skip.is_a?(String)
        @skip_classes = class_names_to_skip
      end

      # return the array of strings value of resolve_skip_classes has been set above
      def self.resolve_skip_classes
        # default to an empty array
        closest_value_of_instance_variable(:@skip_classes) || []
      end

      # yields the provided block for all final classes for the provided base class
      # base_class should be something like BaseModel, BaseSchema or BaseMigration
      def self.for_base_class include_schema_base_classes: false, include_sti_classes: false, only_sti_classes: false, called_from: nil, &block
        called_from ||= caller(1..1).first

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

        # Processes every ancestor of the base_class class.
        method_name = final_child_classes_only ? :for_final_children_of : :for_children_of
        public_send method_name, base_class, skip_classes: resolve_skip_classes do |child_class:|
          # are we skipping the schema base classes, such as `Users::UsersModel`
          unless include_schema_base_classes
            schema_name = child_class.name.split("::").first
            next if child_class.name == "#{schema_name}::#{schema_name}#{child_class.base_type}"
          end

          # are we only processing, or skipping the sti classes
          # classes such as `Communication::TextMessages::WelcomeModel`
          if only_sti_classes
            next unless child_class.name.split("::").count == 3
          elsif ! include_sti_classes
            next if child_class.name.split("::").count == 3
          end

          # resolve the list of arguments which this block is trying to use
          arguments_resolver = ArgumentsResolver.new child_class: child_class, parser_class: parser_class
          block_arguments = arguments_resolver.resolve_arguments_for_block(&block)

          # yield the block with the expected arguments
          instance_exec(**block_arguments, &block)
        end
      rescue
        raise $!, "#{$!}\ncomposer source: #{called_from}", $!.backtrace
      end

      # yields the provided block for all final models which use the provided DSL
      # on the model class or one of it's ancestors.
      #
      # If `include_schema_base_classes` is true, then this block will yeild for schema base
      # classes such as Users::UsersModel, otherwise these classes will be skipped.
      #
      # If `include_sti_classes` is true, then this block will yeild for STI classes such as
      # Communication::TextMessages::WelcomeModel, otherwise these classes will be skipped.
      #
      # If `only_sti_classes` is true, then this block will only yeild for STI classes such
      # as Communication::TextMessages::WelcomeModel.
      #
      # If `skip_inherited_dsls` is true, then this block will only yeild
      # for DSLs which were used directly on the subject class, otherwise this block
      # will yeild for DSLs which were used on the subject class or any of the subject classes
      # ancestors.
      #
      # If `first_use_only` is true, then this block will only yeild once for each subject class
      # which directly uses or inherits use of the provided DSL. The DSL execution which occurs
      # first in the class will be selected, and if the class does not use the DSL then each of
      # the classes ancestors will be tested until an execution is found (only the current class
      # will be tested if skip_inherited_dsls has been set to true).
      def self.dsl_for_base_class dsl_names, include_schema_base_classes: false, include_sti_classes: false, only_sti_classes: false, skip_inherited_dsls: false, first_use_only: false, &block
        called_from = caller(1..1).first

        # remember the parser so we can pass to the ArgumentsResolver and get
        # more useful errors (the value of self would change once we enter the next block)
        parser_class = self

        # Processes every ancestor of the base_class class.
        for_base_class include_schema_base_classes: include_schema_base_classes, include_sti_classes: include_sti_classes, only_sti_classes: only_sti_classes, called_from: called_from do |child_class:|
          # Yields the provided block and provides the requested values for each use of the provided DSL
          on_ancestor_class = !skip_inherited_dsls
          for_dsl dsl_names, on_ancestor_class: on_ancestor_class, first_use_only: first_use_only do |dsl_name:, reader:, dsl_arguments:, dsl_execution:|
            # resolve the list of arguments which this block is trying to use
            arguments_resolver = ArgumentsResolver.new child_class: child_class, parser_class: parser_class, dsl_name: dsl_name, reader: reader, dsl_arguments: dsl_arguments, dsl_execution: dsl_execution
            block_arguments = arguments_resolver.resolve_arguments_for_block(&block)

            # yield the block with the expected arguments
            instance_exec(**block_arguments, &block)
          end
        rescue
          raise $!, "#{$!}\ncomposer source: #{called_from}", $!.backtrace
        end
      end
    end
  end
end
