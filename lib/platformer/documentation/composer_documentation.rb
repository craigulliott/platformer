module Platformer
  class Documentation
    class ComposerDocumentation < Markdown
      def initialize base_path, name, nav_order
        super base_path, "index.md"
        # the jekyll header
        jekyll_header name, has_children: true, has_toc: true, nav_order: nav_order
      end
    end
  end
end
