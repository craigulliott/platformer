module Platformer
  module Composers
    module ActiveRecord
      # A convenience wrapper for a DSL compose parser which removes some
      # common code from all the field parsers
      class FieldParser < BaseFieldParser
        def self.for_fields field_names, &block
          # Process the parser for every decendant of PlatformModel. This includes Models
          # which might be in the class hieracy for a model, but could be abstract and may
          # not have their own coresponding table within the database
          for_children_of PlatformModel do |child_class:|
            # for each time the provided fields DSL was used on this Model
            for_dsl_or_inherited_dsl field_names do |dsl_name:, reader:, name:, dsl_arguments:|
              # only keep the arguments which the block is trying to use
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

                when :model
                  # the ActiveRecord class, this was created and
                  # the result cached within the CreateActiveModels parser
                  final_args[:model] = child_class.active_record_class

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
end
