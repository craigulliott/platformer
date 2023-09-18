module Platformer
  class Documentation
    class Markdown
      attr_reader :file_path

      def initialize base_path, filename
        @base_path = base_path
        @file_path = @base_path + "/#{filename}"
      end

      def jekyll_header title, parent: nil, grand_parent: nil, has_children: false, nav_order: nil
        lines = []
        lines << "---"
        lines << "layout: default"
        lines << "title: #{title.to_s.titleize}"
        lines << "parent: #{parent.to_s.titleize}" unless parent.nil?
        lines << "grand_parent: #{grand_parent.to_s.titleize}" unless grand_parent.nil?
        lines << "has_children: #{has_children}"
        lines << "nav_order: #{nav_order}" unless nav_order.nil?
        lines << "---"

        sections << lines.join("\n")
      end

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
            #{syntax}
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
