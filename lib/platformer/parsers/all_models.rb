module Platformer
  module Parsers
    # Process the parser for every descendant of PlatformModel, which includes
    # models in the class hierarchy that may be abstract and lack a corresponding
    # database table. This class hierarchy adheres to the ActiveRecord convention,
    # which makes this parser the preferred method for parsing our models and generating
    # the relevant business logic for ActiveRecord models.
    #
    # Importantly, the models returned by this parser are not guaranteed to be final
    # models in the class hierarchy, and therefore may not have a corresponding table
    # in the database.
    #
    # This parser returns every model but will only execute the provided block for DSLs
    # specifically invoked on that actual model, ignoring DSLs called on its ancestors.
    # In contrast, the FinalModels parser yields only for classes at the end of the class
    # hierarchy, yet executes the block for DSLs called on any class within that models class
    # hierarchy.
    class AllModels < DSLCompose::Parser
      # Create a convenience method which can be used in parsers which extend this one
      # and abstract away some common code.
      def self.for_dsl dsl_names, &block
        # Processes every ancestor of the PlatformModel class.
        for_children_of PlatformModel do |child_class:|
          # Yields the provided block and provides the requested values for
          # each use of the provided DSL on the current model class (not any
          # of its ancestors)
          for_dsl dsl_names do |dsl_name:, reader:, dsl_arguments:|
            # only keep the arguments which the block is trying to use
            final_args = {}
            desired_arg_names = block.parameters.map(&:last)
            desired_arg_names.each do |arg_name|
              # all the arguments which can be passed to the block
              case arg_name
              when :dsl_name
                final_args[:dsl_name] = dsl_name

              when :model
                # the ActiveRecord class, this was created and
                # the result cached within the CreateActiveModels parser
                final_args[:model] = child_class.active_record_class

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
