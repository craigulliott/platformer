module Platformer
  module Parsers
    # A convenience wrapper for the FinalModels parser which simplifies
    # parsing field DSLs
    class FinalModels
      class ForFields < FinalModels
        class ArgumentNotAvailableError < StandardError
        end

        class ColumnNameError < StandardError
        end

        include ForFieldMacros

        def self.for_fields field_names, &block
          # remember the parser name (class name), so we can present more useful errors
          parser_name = name

          for_dsl field_names do |model_definition_class:, dsl_name:, reader:, dsl_arguments:|
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

              when :allow_null
                final_args[:allow_null] = method_called?(:allow_null)

              when :comment_text
                final_args[:comment_text] = reader.comment&.comment

              when :table
                # the table structure object from DynamicMigrations, this was created and
                # the result cached within the CreateStructure composer
                final_args[:table] = model_definition_class.table_structure

              when :schema
                # the schema structure object from DynamicMigrations, this was created and
                # the result cached within the CreateStructure composer (via the table)
                final_args[:schema] = model_definition_class.table_structure.schema

              when :database
                # the database configuratiom object
                final_args[:database] = model_definition_class.configured_database

              when :reader
                final_args[:reader] = reader

              when :default
                final_args[:default] = reader.default&.default

              when :column_name
                if reader.arguments.has_argument? :name
                  final_args[:column_name] = reader.arguments.name
                elsif reader.arguments.has_argument? :prefix
                  prefix = reader.arguments.prefix
                  name_prepend = prefix.nil? ? "" : "#{prefix}_"
                  case dsl_name
                  when :country_field
                    final_args[:column_name] = :"#{name_prepend}country"
                  when :language_field
                    final_args[:column_name] = :"#{name_prepend}language"
                  when :currency_field
                    final_args[:column_name] = :"#{name_prepend}currency"
                  else
                    raise ColumnNameError, "Unexpected DSL name #{dsl_name}. Cannot build column name."
                  end
                else
                  raise ColumnNameError, "No name or prefix argument is available. Cannot build column name."
                end

              when :column_names
                final_args[:column_names] = []
                if reader.arguments.has_argument? :name
                  final_args[:column_names] << reader.arguments.name
                elsif reader.arguments.has_argument? :prefix
                  prefix = reader.arguments.prefix
                  name_prepend = prefix.nil? ? "" : "#{prefix}_"
                  case dsl_name
                  when :country_field
                    final_args[:column_names] << :"#{name_prepend}country"
                  when :language_field
                    final_args[:column_names] << :"#{name_prepend}language"
                  when :currency_field
                    final_args[:column_names] << :"#{name_prepend}currency"
                  when :phone_number_field
                    final_args[:column_names] << :"#{name_prepend}phone_number"
                    final_args[:column_names] << :"#{name_prepend}dialing_code"
                  else
                    raise ColumnNameError, "Unexpected DSL name #{dsl_name}. Cannot build column name."
                  end
                else
                  raise ColumnNameError, "No name or prefix argument is available. Cannot build column name."
                end

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
            rescue ArgumentNotAvailableError => error
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
