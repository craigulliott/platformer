module Platformer
  module Parsers
    # Apply the parser to every 'final descendant' of BaseModel—a final descendant
    # being a class that inherits from BaseModel but is not further subclassed.
    # Classes identified by this strategy are those with their own data storage, while
    # omitted classes serve merely to share configurations among the classes that extend them.
    #
    # Crucially, classes returned by this parser are guaranteed to have a corresponding table
    # object, which reflects the structure of the database table supporting the model.
    class FinalModels < ClassParser
      base_class BaseModel
      final_child_classes_only true

      class << self
        alias_method :for_final_models, :for_base_class
        alias_method :for_dsl, :dsl_for_base_class
      end

      # the table structure object from DynamicMigrations, this was created and
      # the result cached within the CreateStructure composer
      resolve_argument :table do |model_definition_class:|
        model_definition_class.table_structure
      end

      # the schema structure object from DynamicMigrations, this was created and
      # the result cached within the CreateStructure composer (via the table)
      resolve_argument :schema do |model_definition_class:|
        model_definition_class.table_structure.schema
      end

      # the database configuration object
      resolve_argument :database do |model_definition_class:|
        model_definition_class.configured_database
      end
    end
  end
end
