module Platformer
  module Parsers
    # A convenience wrapper for a DSL compose parser which removes some
    # common code from all the field parsers
    class AllModels
      class ForFields < AllModels
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

              when :active_record_class
                # get the equivilent ActiveRecord class (based on naming conventions)
                # will raise an error if the ActiveRecord class does not exist
                final_args[:active_record_class] = model_class.active_record_class

              when :model_class
                final_args[:model_class] = model_class

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
