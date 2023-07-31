module Platformer
  class Documentation
    def initialize
      @sections = []
    end

    def add_composer_class composer_class
      @sections << ComposerClassDocumenter.new(composer_class).to_markdown
    end

    def to_markdown
      @sections.join "\n\n"
    end
  end
end
