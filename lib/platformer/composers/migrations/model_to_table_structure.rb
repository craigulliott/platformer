module Platformer
  module Composers
    module Migrations
      # This class is used to cache the relationship between a Model definition
      # and it's corresponding DynamicMigrations Table object.
      class ModelToTableStructure < DSLCompose::Parser
        class NoTableStructureForClassError < StandardError
        end

        # Add a relationship between a model class and a table structure object.
        def self.add model_class, table_structure_object
          @model_to_table_structure ||= {}
          @model_to_table_structure[model_class] = table_structure_object
        end

        # Provided with a model class, return the corresponding table structure object.
        # If this relationship does not exist (has not been created via the `add` method)
        # then an error will be raised.
        def self.get_table_structure model_class
          @model_to_table_structure ||= {}

          # assert that the table structure has been added
          if @model_to_table_structure[model_class].nil?
            raise NoTableStructureForClassError, "No table structure object has been added for class `#{model_class}`"
          end

          # return the expected table structure object
          @model_to_table_structure[model_class]
        end
      end
    end
  end
end
