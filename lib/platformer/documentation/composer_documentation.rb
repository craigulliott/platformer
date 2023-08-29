module Platformer
  class Documentation
    class ComposerDocumentation < Markdown
      def initialize base_path
        super base_path, "index.md"
      end
    end
  end
end
