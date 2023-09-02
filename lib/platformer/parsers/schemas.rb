module Platformer
  module Parsers
    # Process the parser for every descendant of BaseSchema.
    class Schemas < DSLCompose::Parser
      class ArgumentNotAvailableError < StandardError
      end

      # yields the provided block for all final schemas
      def self.for_final_schemas &block
        # remember the parser name (class name), so we can present more useful errors
        parser_name = name

        # Processes every ancestor of the BaseSchema class.
        for_final_children_of BaseSchema do |child_class:|
          # only provide the arguments which the block is trying to use
          desired_arg_names = block.parameters.map(&:last)

          # try and resolve the list of requested arguments via a helper which
          # processess the most common arguments
          final_args = ClassSwitchArgumentsHelper.resolve_arguments desired_arg_names, child_class

          unresolved_args = desired_arg_names - final_args.keys
          if unresolved_args.any?
            raise ArgumentNotAvailableError, "Can not find an equivilent argument for name `#{unresolved_args.to_sentence}` within composer `#{parser_name}`"
          end

          # yield the block with the expected arguments
          instance_exec(**final_args, &block)
        end
      end

      # Create a convenience method which can be used in parsers which extend this one
      # and abstract away some common code.
      def self.for_dsl dsl_names, &block
        # Processes every ancestor of the BaseSchema class.
        for_final_schemas do |schema_definition_class:|
          # Yields the provided block and provides the requested values for
          # each use of the provided DSL on the current model class (not any
          # of its ancestors)
          for_dsl dsl_names do |dsl_name:, reader:, dsl_arguments:|
            # only provide the arguments which the block is trying to use
            desired_arg_names = block.parameters.map(&:last)

            # try and resolve the list of requested arguments via a helper which
            # processess the most common arguments
            final_args = ClassSwitchArgumentsHelper.resolve_arguments desired_arg_names, schema_definition_class

            # try and resolve the rest of the requested arguments
            desired_arg_names.each do |arg_name|
              # all the arguments which can be passed to the block
              case arg_name
              when :dsl_name
                final_args[:dsl_name] = dsl_name

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
