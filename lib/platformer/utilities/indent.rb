module Platformer
  module Utilities
    module Indent
      warn "not tested"

      def indent multi_line_string, levels: 1
        spaces = "  " * levels
        multi_line_string.gsub("\n", "\n#{spaces}")
      end
    end
  end
end
