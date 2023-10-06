module Platformer
  module Generators
    warn "not tested"
    class PlatformFile
      class InvalidBaseTypeError < StandardError
      end

      class MissingTableNameError < StandardError
      end

      include Utilities::Indent
      include Utilities::TrimLines
      include Utilities::WordWrap
      include Logger

      def initialize base_type, schema_name, table_name = nil, sti_model_name = nil
        unless Platformer::BASE_TYPES.include? base_type
          raise InvalidBaseTypeError, "Invalid base type: #{base_type} (expected one of: #{Platformer::BASE_TYPES.to_sentence})"
        end

        @base_type = base_type
        @schema_name = schema_name
        @table_name = table_name
        @sti_model_name = sti_model_name

        # to hold the contents of the file as we progressively build it
        @sections = []
      end

      def write_to_file overwrite = false
        ensure_folder_exists
        if exists_on_disk? && overwrite
          warn "Overwriting (file already exists): #{file_path}"
          File.write(file_path, file_contents)

        elsif exists_on_disk?
          warn "Skipping (file already exists): #{file_path}"

        else
          File.write(file_path, file_contents)
          log.info "Generated: #{file_path}"
        end
      end

      def write_to_file!
        write_to_file true
      end

      private

      attr_reader :base_type
      attr_reader :schema_name

      # add content to the file
      def add_section content
        @sections << content.strip
      end

      def file_contents
        if sti_class?
          <<~RUBY
            module #{module_name}
              module #{sti_module_name}
                class #{class_name} < #{base_class_name}
                  #{indent @sections.join("\n\n"), levels: 2}
                end
              end
            end
          RUBY
        else
          <<~RUBY
            module #{module_name}
              class #{class_name} < #{base_class_name}
                #{indent @sections.join("\n\n"), levels: 2}
              end
            end
          RUBY
        end
      end

      def base_path
        if base_class?
          schema_base_path
        elsif sti_class?
          sti_base_path
        else
          schema_base_type_base_path
        end
      end

      def schema_base_type_base_path
        Platformer.root "platform/#{schema_name}/#{base_type.to_s.pluralize}"
      end

      def schema_base_path
        Platformer.root "platform/#{schema_name}"
      end

      def sti_base_path
        Platformer.root "platform/#{schema_name}/#{base_type.to_s.pluralize}/#{table_name.to_s.pluralize}"
      end

      def module_name
        schema_name.to_s.camelize
      end

      def sti_module_name
        table_name.to_s.camelize
      end

      def file_path
        base_path + "/#{filename}"
      end

      def filename
        if base_class?
          "#{schema_name}_#{base_type}.rb"
        elsif sti_class?
          "#{sti_model_name}_#{base_type}.rb"
        else
          "#{table_name.to_s.singularize}_#{base_type}.rb"
        end
      end

      def class_name
        if base_class?
          "#{schema_name}_#{base_type}".camelize
        elsif sti_class?
          "#{sti_model_name}_#{base_type}".camelize
        else
          "#{table_name.to_s.singularize}_#{base_type}".camelize
        end
      end

      def base_class_name
        if base_class?
          "Platform#{base_type.to_s.camelize}"
        elsif sti_class?
          "#{table_name.to_s.singularize}_#{base_type}".camelize
        else
          "#{schema_name.to_s.camelize}#{base_type.to_s.camelize}"
        end
      end

      def table_name
        if @table_name.nil?
          raise MissingTableNameError, "Missing table name for this generator (schema_name: #{schema_name}, base_type: #{base_type})"
        end
        @table_name
      end

      def sti_model_name
        if @sti_model_name.nil?
          raise MissingTableNameError, "Missing sti_model_name name for this generator (schema_name: #{schema_name}, base_type: #{base_type})"
        end
        @sti_model_name
      end

      def base_class?
        @table_name.nil?
      end

      def sti_class?
        !@sti_model_name.nil?
      end

      def exists_on_disk?
        File.exist? file_path
      end

      def ensure_folder_exists
        FileUtils.mkdir_p base_path
      end
    end
  end
end
