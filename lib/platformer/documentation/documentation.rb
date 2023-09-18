module Platformer
  class Documentation
    def initialize name, composer_class, base_path
      @name = name
      @composer_class = composer_class
      @base_path = base_path
    end

    def generate
      create_composer_base_folder

      # the main composer documentation, this will contain a description
      # and links to the DSLs and namespaces.
      composer_documentation = ComposerDocumentation.new composer_base_path, @name

      # extract the description from the composer class
      composer_documentation.text @composer_class.class_description

      # keep track of our namespaces so we only create a single file for each
      namespaces = {}

      # process each DSL
      DSLCompose::DSLs.class_dsls(@composer_class).each do |dsl|
        # if this DSL is namespaced
        if dsl.namespace
          namespace_title = dsl.namespace.to_s.titleize

          # if this is the first time we've enountered it, then create it and add a link
          # to the main composer document, this namespace_documentation file will be
          # written to disk when we are done
          if namespaces[dsl.namespace].nil?
            namespaces[dsl.namespace] = NamespaceDocumentation.new composer_base_path, dsl.namespace, @name
            composer_documentation.link_document namespace_title, namespaces[dsl.namespace]
          end

          # create the DSL documentation file
          dsl_documentation = DSLDocumentation.new(composer_base_path, dsl.name, @composer_class, @name, dsl, dsl.namespace)

          # add a link to this DSL in the namespace file
          dsl_title = dsl.title || dsl.name.to_s.titleize
          namespaces[dsl.namespace].link_document dsl_title, dsl_documentation

        else
          dsl_documentation = DSLDocumentation.new(composer_base_path, dsl.name, @composer_class, @name, dsl)

          # link to this DSL from the main composer file
          dsl_title = dsl.title || dsl.name.to_s.titleize
          composer_documentation.link_document dsl_title, dsl_documentation
        end

        dsl_documentation.write_to_file
      end

      namespaces.values.each(&:write_to_file)
      composer_documentation.write_to_file
    end

    private

    def composer_base_path
      File.expand_path @name.to_s, @base_path
    end

    def create_composer_base_folder
      # will raise an error if the folder already exists
      FileUtils.mkdir composer_base_path
    end
  end
end
