module Platformer
  class Documentation
    def initialize name, composer_class, base_path, nav_order
      @name = name
      @composer_class = composer_class
      @base_path = base_path
      @nav_order = nav_order
    end

    def generate
      create_composer_base_folder

      # the main composer documentation, this will contain a description
      # and links to the DSLs and namespaces.
      composer_documentation = ComposerDocumentation.new composer_base_path, @name, @nav_order

      # name of this composer
      composer_documentation.h1 @name.to_s.titleize

      # extract the description from the composer class and add it to the top
      # of the file
      composer_documentation.text @composer_class.class_description

      # keep track of our namespaces so we only create a single file for each
      namespaces = {}

      # process each DSL
      DSLCompose::DSLs.class_dsls(@composer_class).each do |dsl|
        # if this DSL is namespaced
        if dsl.namespace
          # if this is the first time we've enountered it, then create the namespace documentation file
          if namespaces[dsl.namespace].nil?
            namespaces[dsl.namespace] = NamespaceDocumentation.new composer_base_path, dsl.namespace, @name
          end

          # create the DSL documentation file
          dsl_documentation = DSLDocumentation.new(composer_base_path, dsl.name, @composer_class, @name, dsl, dsl.namespace)

        else
          dsl_documentation = DSLDocumentation.new(composer_base_path, dsl.name, @composer_class, @name, dsl)
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
