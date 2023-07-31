module Platformer
  class Documentation
    class ArgumentsDocumenter < Markdown
      def initialize arguments
        @arguments = arguments

        # documentation for each argument
        h3 "Arguments"

        # required arguments first
        h4 "Required arguments"
        if arguments.required_arguments.any?
          arguments.required_arguments.each do |argument|
            h5 "#{argument.name} (type: #{argument.type})"
            text argument.description
          end
        end

        # optional arguments
        h4 "Optional arguments"
        if arguments.optional_arguments.any?
          arguments.optional_arguments.each do |argument|
            h5 "#{argument.name} (type: `#{argument.type})`"
            text argument.description
          end
        end
      end

      # returns a simple one line string ehich summarizes the arguments
      def summary_string
        # any required arguments
        args = @arguments.required_arguments.map(&:name)
        # add any optional arguments
        @arguments.optional_arguments.each do |arg|
          args << "#{arg.name}: #{arg.type}"
        end
        args.join(", ")
      end
    end
  end
end
