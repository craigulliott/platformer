# frozen_string_literal: true

module Platformer
  module Composers
    module Migrations
      class CreateTables < DSLCompose::Parser
        # Create the postgres schema and table for each model
        for_children_of PlatformModel do |child_class:|
          # get the ActiveRecord class from each Model class
          active_record_class = ClassMap.get_active_record_class_from_model_class child_class
          # get the schema name and table name
          schema_name, table_name = active_record_class.table_name.split(".")
          # create the schema if it doesn't exist

          # create the table (will fail loudly if the table already exists)
        end
      end
    end
  end
end
