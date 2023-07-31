module Platformer
  class Documentation
    class Markdown
      # given a string, creates a markdown h1
      def h1 header
        unless header.nil? || header == ""
          markdown = "# #{header.to_s.strip}"
          sections << markdown
          markdown
        end
      end

      # given a string, creates a markdown h2
      def h2 header
        unless header.nil? || header == ""
          markdown = "## #{header.to_s.strip}"
          sections << markdown
          markdown
        end
      end

      # given a string, creates a markdown h3
      def h3 header
        unless header.nil? || header == ""
          markdown = "### #{header.to_s.strip}"
          sections << markdown
          markdown
        end
      end

      # given a string, creates a markdown h4
      def h4 header
        unless header.nil? || header == ""
          markdown = "#### #{header.to_s.strip}"
          sections << markdown
          markdown
        end
      end

      # given a string, creates a markdown h4
      def h5 header
        unless header.nil? || header == ""
          markdown = "##### #{header.to_s.strip}"
          sections << markdown
          markdown
        end
      end

      # given a string, creates a markdown h4
      def h6 header
        unless header.nil? || header == ""
          markdown = "###### #{header.to_s.strip}"
          sections << markdown
          markdown
        end
      end

      # add a section of documentation
      def text documentation
        unless documentation.nil? || documentation == ""
          markdown = sanitize_section documentation
          sections << markdown
          markdown
        end
      end

      # add a code block
      def code syntax, language = :ruby
        unless syntax.nil? || syntax == ""
          markdown = sanitize_section <<-CODEBLOCK
            ```#{language}
            #{sanitize_section syntax}
            ```
          CODEBLOCK
          sections << markdown
          markdown
        end
      end

      # Clears the database configuration object, this is primarily used from witin
      # the test suite
      def to_markdown
        sections.join "\n\n"
      end

      private

      def sections
        @sections ||= []
      end

      # change snake case and lowercase space selerated words into title case
      def titleize string
        string.to_s.split(/_| /).map { |word| word[0] && (word[0].upcase + word[1..-1]) }.join(" ").strip
      end

      # This method is used to trim empty lines from the start and end of
      # a block of markdown, it will also fix the indentation of heredoc
      # strings by removing the leading whitespace from the first line, and
      # that same amount of white space from every other line
      def sanitize_section string
        # replace all tabs with spaces
        string = string.gsub(/\t/, "  ")
        # remove empty lines from the start of the string
        string = string.gsub(/\A( *\n)+/, "")
        # remove empty lines from the end of the string
        string = string.gsub(/( *\n)+\Z/, "")
        # removes the number of leading spaces on the first line, from
        # all the other lines
        string.gsub(/^#{string[/\A */]}/, "")
      end
    end
  end
end
