module Platformer
  module Parsers
    # Apply the parser to every models definition file except BaseModel and PlatformModel.
    # This includes schema base classes, normal models, sti base classes and sti classes
    # base
    class Models < ClassParser
      base_class BaseModel
      final_child_classes_only false
      skip_classes "PlatformModel"

      class << self
        alias_method :for_models, :for_base_class
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

      # is this a schema base class, such as Users::UsersModel
      resolve_argument :is_schema_base_class do |model_definition_class:|
        schema_name = model_definition_class.name.split("::").first
        model_definition_class.name == "#{schema_name}::#{schema_name}Model"
      end

      # is this an STI model class, such as Communication::TextMessages::WelcomeModel
      resolve_argument :is_sti_class do |model_definition_class:|
        model_definition_class.name.split("::").count == 3
      end
    end
  end
end
