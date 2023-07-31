module Platformer
  class Documentation
    class DSLDocumenter < Markdown
      # document a specific DSL
      def initialize composer_class, dsl
        # the name and description of this DSL
        h2 "#{titleize dsl.name} `#{composer_class.name}.#{dsl.name}`"
        text dsl.description

        arguments_summary = ArgumentsDocumenter.new(dsl.arguments).summary_string

        # a ruby preview of this method with all possible arguments
        code <<-CODE
          class MyModel
            #{dsl.name} #{arguments_summary}
          end
        CODE

        if dsl.arguments.any?
          text ArgumentsDocumenter.new(dsl.arguments).to_markdown
        end

        # documentation for each method
        if dsl.dsl_methods.any?
          h3 "Additional Configuration"

          dsl.dsl_methods.each do |dsl_method|
            text DSLMethodDocumenter.new(dsl, dsl_method).to_markdown
          end

        end
      end
    end
  end
end
