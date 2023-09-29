module Platformer
  module Parsers
    class ArgumentsResolver
      class ArgumentNotAvailableError < StandardError
      end

      def initialize child_class:, parser_class:, dsl_name: nil, reader: nil, dsl_arguments: nil, dsl_execution: nil
        @child_class = child_class
        @parser_class = parser_class
        @dsl_name = dsl_name
        @reader = reader
        @dsl_arguments = dsl_arguments
        @dsl_execution = dsl_execution
      end

      warn "not tested"
      def resolve_arguments_for_block &block
        # only resolve the arguments which the block is trying to use
        desired_arg_names = block.parameters.map(&:last)

        # resolve the base arguments
        final_args = resolve_base_arguments desired_arg_names

        # the list of argument names which were not resolved by the base arguments
        unresolved_argument_names = desired_arg_names - final_args.keys

        # try and resolve the missing arguments with custom resolvers
        # which are added to the various parsers via the resolve_argument
        # singleton method
        unresolved_argument_names.each do |arg_name|
          # otherwise, look in the child class
          if (resolver = argument_resolver(arg_name))
            # resolve the list of arguments required by the resolver using
            # `resolve_base_arguments` (do not call `resolve_arguments_for_block` here as
            # it could result in an infinite loop)
            desired_resolver_arg_names = resolver.parameters.map(&:last)
            resolver_args = resolve_base_arguments(desired_resolver_arg_names)
            # yeild the resolver and store the arguments value in the final_args
            resolver_value = instance_exec(**resolver_args, &resolver)
            final_args[arg_name] = resolver_value

          # otherwise, if it wasnt already set by the common args helper, then raise an error
          elsif @dsl_name
            raise ArgumentNotAvailableError, "Cannot resolve block argument `#{arg_name}` for DSL `#{@dsl_name}` within composer `#{parser_name}`"
          else
            raise ArgumentNotAvailableError, "Cannot resolve block argument `#{arg_name}` for composer `#{parser_name}`"
          end
        end

        # return the final args
        final_args
      end

      private

      def resolve_base_arguments desired_arg_names
        final_base_args = {}

        if @dsl_name && desired_arg_names.include?(:dsl_name)
          final_base_args[:dsl_name] = @dsl_name
        end

        if @reader && desired_arg_names.include?(:reader)
          final_base_args[:reader] = @reader
        end

        if @dsl_arguments && desired_arg_names.include?(:dsl_arguments)
          final_base_args[:dsl_arguments] = @dsl_arguments
        end

        if @dsl_execution && desired_arg_names.include?(:dsl_execution)
          final_base_args[:dsl_execution] = @dsl_execution
        end

        desired_arg_names.each do |arg_name|
          # all the arguments which can be passed to the block
          case arg_name
          when :child_class
            final_base_args[:child_class] = @child_class

          when :callback_definition_class
            final_base_args[:callback_definition_class] = @child_class.callback_definition_class

          when :job_definition_class
            final_base_args[:job_definition_class] = @child_class.job_definition_class

          when :model_definition_class
            final_base_args[:model_definition_class] = @child_class.model_definition_class

          when :mutation_definition_class
            final_base_args[:mutation_definition_class] = @child_class.mutation_definition_class

          when :policy_definition_class
            final_base_args[:policy_definition_class] = @child_class.policy_definition_class

          when :presenter_definition_class
            final_base_args[:presenter_definition_class] = @child_class.presenter_definition_class

          when :schema_definition_class
            final_base_args[:schema_definition_class] = @child_class.schema_definition_class

          when :service_definition_class
            final_base_args[:service_definition_class] = @child_class.service_definition_class

          when :subscription_definition_class
            final_base_args[:subscription_definition_class] = @child_class.subscription_definition_class

          when :active_record_class
            # get the equivilent ActiveRecord class (based on naming conventions)
            # will raise an error if the ActiveRecord class does not exist
            final_base_args[:active_record_class] = @child_class.active_record_class

          when :presenter_class
            # get the equivilent Presenter class (based on naming conventions)
            # will return nil if the desired Presenter class does not exist
            final_base_args[:presenter_class] = @child_class.presenter_class

          when :graphql_type_class
            # get the equivilent GraphQL Type class (based on naming conventions)
            # will return nil if the desired Type class does not exist
            final_base_args[:graphql_type_class] = @child_class.graphql_type_class

          when :schema_reader
            final_base_args[:schema_reader] = DSLReaders::Schema.new(@child_class.schema_definition_class)

          when :model_reader
            final_base_args[:model_reader] = DSLReaders::Model.new(@child_class.model_definition_class)

          when :public_name
            final_base_args[:public_name] = DSLReaders::Model.new(@child_class.model_definition_class).public_name

          when :module_name
            final_base_args[:module_name] = @child_class.name.split("::").first

          # if the argument exists within the dsl's arguments, then
          # resolve it automatically to that value
          else
            if @dsl_arguments&.key?(arg_name)
              final_base_args[arg_name] = @dsl_arguments[arg_name]
            end
          end
        end
        # return the final base args
        final_base_args
      end

      def argument_resolver arg_name
        @parser_class.argument_resolver arg_name
      end

      def parser_name
        @parser_class.name
      end
    end
  end
end
