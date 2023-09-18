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

        # the description of this DSL
        text @dsl.description

        arguments_summary = arguments_example_usage_string @dsl.arguments

        # a ruby preview of this method with all possible arguments
        code <<~CODE
          class My#{composer_base_type} < Platformer#{composer_base_type}
            #{@dsl.name} #{arguments_summary}
          end
        CODE

        if @dsl.arguments.any?
          arguments_markdown @dsl.arguments
        end

        # documentation for each method
        if @dsl.dsl_methods.any?
          subsection_header "Additional Configuration Options"

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
        dsl_method_arguments_summary = arguments_example_usage_string @dsl.arguments, true

        # the name and description of this DSL method
        subsection_header dsl_method.name.to_s.titleize
        text dsl_method.description

        if dsl_arguments_summary
          dsl_arguments_summary = " " + dsl_arguments_summary
        end

        # a ruby preview of this method with all possible arguments
        code <<~CODE
          class My#{composer_base_type} < Platform#{composer_base_type}
            #{@dsl.name}#{dsl_arguments_summary} do
              ...
              #{dsl_method.name} #{dsl_method_arguments_summary}
              ...
            end
          end
        CODE

        if dsl_method.arguments.any?
          arguments_markdown dsl_method.arguments
        end
      end

      def arguments_markdown arguments
        # documentation for each argument
        subsection_header "Arguments"

        # for each required and optional argument
        (arguments.required_arguments + arguments.optional_arguments).each do |argument|
          definition_list "#{argument.name} (#{arg_type_str argument})", argument.description
        end
      end

      # example argument use string
      def arguments_example_usage_string arguments, include_optional_arguments = false
        string_parts = []
        # add any required arguments
        arguments.required_arguments.each do |argument|
          string_parts << case argument.type
          when :symbol
            ":#{argument.name}"
          when :class
            "\"#{argument.name.to_s.titleize}\""
          else
            argument.name.to_s
          end
        end
        # add any optional arguments
        if include_optional_arguments
          arguments.optional_arguments.each do |argument|
            type = case argument.type
            when :symbol
              ":#{argument.name}"
            when :class
              "\"#{argument.name.to_s.titleize}\""
            else
              argument.name.to_s
            end

            string_parts << if argument.array
              "#{argument.name}: [#{type}]"
            else
              "#{argument.name}: #{type}"
            end
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
          argument_type = "[#{argument_type}]"
        end
        optional_or_required = argument.required ? "required" : "optional"
        "#{optional_or_required} #{argument_type}"
      end
    end
  end
end
