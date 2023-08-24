module Platformer
  module Composers
    module Migrations
      # A convenience wrapper for a DSL compose parser which removes some
      # common code from all the field parsers
      class FieldParser < BaseFieldParser
        class ArgumentNotAvailableError < StandardError
        end

        def self.for_fields field_names, &block
          # Process the parser for every decendant of PlatformModel which does not have
          # it's own decendents. These represent Models which will have a coresponding
          # ActiveRecord class created for them, and thus a table within the database
          for_final_children_of PlatformModel do |child_class:|
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

                when :table
                  # the table structure object from DynamicMigrations, this was created and
                  # the result cached within the CreateStructure parser
                  final_args[:table] = child_class.table_structure

                when :schema
                  # the schema structure object from DynamicMigrations, this was created and
                  # the result cached within the CreateStructure parser (via the table)
                  final_args[:schema] = child_class.table_structure.schema

                when :database
                  # the database configuratiom object
                  final_args[:database] = child_class.configured_database

                when :column
                  # Get the coresponding column object from DynamicMigrations for this field
                  # column is not available until the first field composer runs, and builds it
                  final_args[:column] = child_class.table_structure.column(name)

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
