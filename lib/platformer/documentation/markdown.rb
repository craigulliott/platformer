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
          markdown = documentation.strip
          sections << markdown
          markdown
        end
      end

      # add a code block
      def code syntax, language = :ruby
        unless syntax.nil? || syntax == ""
          markdown = <<~CODEBLOCK.strip
            ```#{language}
            #{syntax}
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
    end
  end
end
