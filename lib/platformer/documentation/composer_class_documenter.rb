module Platformer
  class Documentation
    class ComposerClassDocumenter < Markdown
      # document a composer class, such as PlatformModel
      def initialize composer_class
        h1 composer_class.name

        text composer_class.class_description

        text <<-DOCS
          You can use the following methods to configure this class
        DOCS

        DSLCompose::DSLs.class_dsls(composer_class).each do |dsl|
          text DSLDocumenter.new(composer_class, dsl).to_markdown
        end
      end
    end
  end
end
