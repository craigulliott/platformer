module Platformer
  class Documentation
    class Markdown
      attr_reader :file_path

      def initialize base_path, filename
        @base_path = base_path
        @file_path = @base_path + "/#{filename}"
      end

      warn "not tested"
      def jekyll_header title, parent: nil, grand_parent: nil, has_children: false, nav_order: nil, has_toc: false
        lines = []
        lines << "---"
        lines << "layout: default"
        lines << "title: #{title.to_s.titleize}"
        lines << "parent: #{parent.to_s.titleize}" unless parent.nil?
        lines << "grand_parent: #{grand_parent.to_s.titleize}" unless grand_parent.nil?
        lines << "has_children: #{has_children}"
        lines << "has_toc: #{has_toc}"
        lines << "nav_order: #{nav_order}" unless nav_order.nil?

        lines << if grand_parent
          "permalink: /#{grand_parent}/#{parent}/#{title}"
        elsif parent
          "permalink: /#{parent}/#{title}"
        else
          "permalink: /#{title}"
        end

        lines << "---"

        sections << lines.join("\n")
      end

      def table_of_contents collapsible = false
        sections << if collapsible
          <<~MARKDOWN
            <details open markdown="block">
              <summary>
                Table of contents
              </summary>
              {: .text-delta }
            TOC
            {:toc}
            </details>
          MARKDOWN
        else
          <<~MARKDOWN
            - TOC
            {:toc}
          MARKDOWN
        end
      end

      # given a string, creates a markdown h1
      def h1 header, include_in_toc = false
        unless header.nil? || header == ""
          toc = include_in_toc ? "" : "\n{: .no_toc }"
          markdown = "# #{header.to_s.strip}#{toc}"
          sections << markdown
          markdown
        end
      end

      # given a string, creates a markdown h2
      def h2 header, include_in_toc = true
        unless header.nil? || header == ""
          toc = include_in_toc ? "" : "\n{: .no_toc }"
          markdown = "## #{header.to_s.strip}#{toc}"
          sections << markdown
          markdown
        end
      end

      # given a string, creates a markdown h3
      def h3 header, include_in_toc = true
        unless header.nil? || header == ""
          toc = include_in_toc ? "" : "\n{: .no_toc }"
          markdown = "### #{header.to_s.strip}#{toc}"
          sections << markdown
          markdown
        end
      end

      # given a string, creates a markdown h4
      def h4 header, include_in_toc = true
        unless header.nil? || header == ""
          toc = include_in_toc ? "" : "\n{: .no_toc }"
          markdown = "#### #{header.to_s.strip}#{toc}"
          sections << markdown
          markdown
        end
      end

      # given a string, creates a markdown h4
      def h5 header, include_in_toc = true
        unless header.nil? || header == ""
          toc = include_in_toc ? "" : "\n{: .no_toc }"
          markdown = "##### #{header.to_s.strip}#{toc}"
          sections << markdown
          markdown
        end
      end

      # given a string, creates a markdown h4
      def h6 header, include_in_toc = true
        unless header.nil? || header == ""
          toc = include_in_toc ? "" : "\n{: .no_toc }"
          markdown = "###### #{header.to_s.strip}#{toc}"
          sections << markdown
          markdown
        end
      end

      # a header which used bold text
      def subsection_header header
        unless header.nil? || header == ""
          markdown = "**#{header.to_s.strip}**"
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
            #{syntax.strip}
            ```
          CODEBLOCK
          sections << markdown
          markdown
        end
      end

      # definitions can be a single string or an array of strings
      def definition_list item_name, definitions
        # if a single definition is passed in, wrap it in an array
        definitions = [definitions] unless definitions.is_a? Array

        lines = []
        lines << item_name.to_s.strip
        definitions.each do |definition|
          lines << ":   #{definition.to_s.tr("\n", " ").strip}"
        end

        markdown = lines.join("\n")
        sections << markdown
        markdown
      end

      warn "not tested"
      def table header, rows
        lines = []
        lines << "| #{header.join(" | ")} |"
        lines << "|#{header.map { |header| ":---" }.join("|")}|"
        rows.each do |row|
          lines << "| #{row.map { |h| h.to_s.tr("\n", " ") }.join(" | ")} |"
        end

        sections << lines.join("\n")
      end

      def link_document name, other_markdown_document
        h2 name

        relative_path = other_markdown_document.file_path.gsub(@base_path, "").gsub(/^\//, "")
        sections << <<~IMPORT
          [#{name}](#{relative_path})
        IMPORT
      end

      def write_to_file
        ensure_folder_exists
        puts "Creating documentation file: #{@file_path}"
        File.write(@file_path, to_markdown)
      end

      # Clears the database configuration object, this is primarily used from witin
      # the test suite
      def to_markdown
        sections.join "\n\n"
      end

      private

      def ensure_folder_exists
        FileUtils.mkdir_p @base_path
      end

      def sections
        @sections ||= []
      end
    end
  end
end
