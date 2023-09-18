module Platformer
  class Documentation
    class ComposerDocumentation < Markdown
      def initialize base_path, name
        super base_path, "index.md"
        # the jekyll header
        jekyll_header name, has_children: true
      end
    end
  end
end
