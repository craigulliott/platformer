module Platformer
  module Utilities
    module TrimLines
      # todo: not tested

      def trim_lines string
        string.split("\n").map(&:rstrip).join("\n")
      end
    end
  end
end
