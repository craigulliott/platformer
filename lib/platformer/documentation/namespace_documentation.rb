module Platformer
  class Documentation
    class NamespaceDocumentation < Markdown
      def initialize base_path, namespace_name, parent_name
        namespace_base_path = File.expand_path namespace_name.to_s, base_path
        super namespace_base_path, "index.md"
        # the jekyll header
        jekyll_header namespace_name, parent: parent_name, has_children: true, has_toc: true

        h1 namespace_name.to_s.titleize
      end
    end
  end
end
