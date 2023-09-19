module Platformer
  class Documentation
    class DSLDocumentation < Markdown
      def initialize base_path, name, composer_class, composer_name, dsl, namespace = nil
        dsl_base_path = base_path
        unless namespace.nil?
          dsl_base_path += "/#{namespace}"
        end
        super dsl_base_path, "#{name}.md"

        @name = name
        @namespace = namespace
        @composer_name = composer_name
        @composer_class = composer_class
        @dsl = dsl

        build_markdown
      end

      # document a specific DSL
      def build_markdown
        # the jekyll header
        if @namespace
          jekyll_header @name, parent: @namespace, grand_parent: @composer_name
        else
          jekyll_header @name, parent: @composer_name
        end

        h1 @name.to_s.titleize

        # the description of this DSL
        text @dsl.description

        arguments_summary = arguments_example_usage_string @dsl.arguments
        all_arguments_summary = arguments_example_usage_string @dsl.arguments, true

        # a ruby preview of this method
        if arguments_summary != all_arguments_summary
          code <<~CODE
            class My#{composer_base_type} < Platform#{composer_base_type}
              # required arguments only
              #{@dsl.name} #{arguments_summary}
              # all possible arguments
              #{@dsl.name} #{all_arguments_summary}
            end
          CODE
        else
          code <<~CODE
            class My#{composer_base_type} < Platform#{composer_base_type}
              #{@dsl.name} #{arguments_summary}
            end
          CODE
        end

        if @dsl.arguments.any?
          h4 "#{@dsl.name.to_s.titleize} Arguments", false

          arguments_markdown @dsl.arguments
        end

        # documentation for each method
        if @dsl.dsl_methods.any?
          h2 "Additional Configuration", false

          text <<~MARKDOWN
            You can further configure the #{@name.to_s.titleize} by using the following methods:
          MARKDOWN

          if @dsl.dsl_methods.count > 3
            table_of_contents
          end

          @dsl.dsl_methods.each do |dsl_method|
            dsl_method_markdown dsl_method
          end

        end
      end

      private

      def composer_base_type
        @composer_base_type ||= @composer_class.name.sub(/\APlatformer::Base/, "")
      end

      def dsl_method_markdown dsl_method
        # a summary of the dsl and the methods arguments
        dsl_arguments_summary = arguments_example_usage_string @dsl.arguments
        dsl_method_arguments_summary = arguments_example_usage_string dsl_method.arguments
        dsl_method_all_arguments_summary = arguments_example_usage_string dsl_method.arguments, true

        # the name and description of this DSL method
        h3 dsl_method.name.to_s.titleize
        text dsl_method.description

        if dsl_arguments_summary
          dsl_arguments_summary = " " + dsl_arguments_summary
        end

        # a ruby preview of this method
        if dsl_method_arguments_summary != dsl_method_all_arguments_summary
          code <<~CODE
            class My#{composer_base_type} < Platform#{composer_base_type}
              #{@dsl.name}#{dsl_arguments_summary} do
                ...
                # required arguments only
                #{dsl_method.name} #{dsl_method_arguments_summary}
                # all possible arguments
                #{dsl_method.name} #{dsl_method_all_arguments_summary}
                ...
              end
            end
          CODE
        else
          code <<~CODE
            class My#{composer_base_type} < Platform#{composer_base_type}
              #{@dsl.name}#{dsl_arguments_summary} do
                ...
                #{dsl_method.name} #{dsl_method_arguments_summary}
                ...
              end
            end
          CODE
        end

        if dsl_method.arguments.any?
          h4 "#{dsl_method.name.to_s.titleize} Arguments", false

          arguments_markdown dsl_method.arguments
        end
      end

      def arguments_markdown arguments
        # documentation for each argument

        header = ["Name", "Required", "Type", "Description"]
        rows = []
        # for each required and optional argument
        (arguments.required_arguments + arguments.optional_arguments).each do |argument|
          arg_type = if argument.type == :symbol && argument.in_validation.present?
            "`:" + argument.in_validation.instance_variable_get(:@values).to_sentence(last_word_connector: "` or `:", words_connector: "`, `:") + "`"
          else
            arg_type_str(argument)
          end

          required_string = argument.required ? "required" : "optional"
          rows << [argument.name, required_string, arg_type, argument.description]
        end

        table header, rows
      end

      def argument_example_value argument
        type = case argument.type
        when :symbol
          ":value"
        when :class
          "\"#{argument.name.to_s.titleize.delete(" ")}\""
        when :string
          "\"#{argument.name.to_s.titleize.downcase}\""
        when :boolean
          "false"
        when :integer
          123
        when :float
          123
        else
          argument.name.to_s
        end

        argument.array ? "[#{type}]" : type
      end

      # example argument use string
      def arguments_example_usage_string arguments, include_optional_arguments = false
        string_parts = []
        # add any required arguments
        arguments.required_arguments.each do |argument|
          string_parts << argument_example_value(argument)
        end
        # add any optional arguments
        if include_optional_arguments
          arguments.optional_arguments.each do |argument|
            type = argument_example_value(argument)
            string_parts << "#{argument.name}: #{type}"
          end
        end
        string_parts.join(", ")
      end

      # returns a simple one line string which summarizes the arguments
      def summary_string
        # any required arguments
        string_parts = []
        # add any optional arguments
        (arguments.required_arguments + arguments.optional_arguments).each do |argument|
          string_parts << "#{argument.name} (#{arg_type_str argument})"
        end
        string_parts.join(", ")
      end

      def arg_type_str argument
        argument_type = argument.type.to_s.titleize
        if argument.array
          argument_type = "Array[#{argument_type}]"
        end
        argument_type
      end
    end
  end
end
