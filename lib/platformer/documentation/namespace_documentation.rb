module Platformer
  class Documentation
    class NamespaceDocumentation < Markdown
      def initialize base_path, namespace
        namespace_base_path = File.expand_path base_path + "/#{namespace}"
        super namespace_base_path, "index.md"
      end
    end
  end
end
