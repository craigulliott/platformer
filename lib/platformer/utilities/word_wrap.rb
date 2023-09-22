module Platformer
  module Utilities
    module WordWrap
      warn "not tested"
      # splitting the string into words and then adding them one by
      # one to the result string, adding line breaks when the length
      # exceeds a certain limit
      def word_wrap(text, line_length:, indent: true)
        words = text.split(" ")
        wrapped_text = ""
        line = ""

        words.each do |word|
          if line.length + word.length <= line_length
            line << " " unless line.empty?
            line << word
          else
            wrapped_text << line << "\n#{indent ? "  " : ""}"
            line = word
          end
        end

        wrapped_text << line # Add the last line

        wrapped_text
      end
    end
  end
end
