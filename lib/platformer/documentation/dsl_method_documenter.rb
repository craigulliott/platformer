module Platformer
  class Documentation
    class DSLMethodDocumenter < Markdown
      def initialize dsl, dsl_method
        # a summary of the dsl and the methods arguments
        dsl_arguments_summary = ArgumentsDocumenter.new(dsl.arguments).summary_string
        dsl_method_arguments_summary = ArgumentsDocumenter.new(dsl_method.arguments).summary_string

        # the name and description of this DSL method
        if dsl_method_arguments_summary
          h3 "#{titleize dsl_method.name} (`#{dsl_method.name} #{dsl_method_arguments_summary}`)"
        else
          h3 "#{titleize dsl_method.name} (`#{dsl_method.name}`)"
        end
        text dsl_method.description

        # a ruby preview of this method with all possible arguments
        code <<~CODE
          class MyModel
            #{dsl.name} #{dsl_arguments_summary} do
              #{dsl_method.name} #{dsl_method_arguments_summary}
            end
          end
        CODE

        if dsl_method.arguments.any?
          text ArgumentsDocumenter.new(dsl_method.arguments).to_markdown
        end
      end
    end
  end
end
