# frozen_string_literal: true

module Platformer
  module Composers
    module Migrations
      # Create a table within DynamicMigrations for the correct server, database and
      # schema to represent the table which is expected to exist for each model which
      # has been defined for our system.
      class CreateStructure < DSLCompose::Parser
        # Process the parser for every decendant of PlatformModel which does not have
        # it's own decendents. These represent Models which will have a coresponding
        # ActiveRecord class created for them, and thus a table within the database
        for_final_children_of PlatformModel do |child_class:|
          # Create a dsl reader for the Database DSLs.
          dsl_reader = DatabaseDSLReader.new child_class

          # Get the table name from the active record class.
          table_name = ClassMap.active_record_table_name_from_model_class(child_class)

          # Get the database server object using the `server_type` and `server_name`
          # configuration values. These values come from the most recent use of the
          # database related DSLs which were used on the `child_class` or one it's
          # ancestors.
          #
          # The first time this server is requested, the Databases class will create
          # a new Server object within Platformer which loads configuration from
          # config/database.yaml and provides functioanlity to help manage connections
          # to the requested database. It will also create a representation of this
          # server within DynamicMigrations, this DynamicMigrations Server object can
          # be accesed via the `server.structure` method.
          server = Databases.server(dsl_reader.server_type, dsl_reader.server_name)

          # Get either the current or default database object from the server object,
          # If a database_name was not provided for this `child_class` (via the
          # corresponding DSL) then the default database is used.
          database = dsl_reader.has_database_name? ? server.database(dsl_reader.database_name) : server.default_database

          # The database object has a reference to a corresponding DynamicMigrations
          # database object. We get this object, as we will be adding schema and tables to
          # it below.
          database_structure = database.structure

          # The name of the schema where this table should be placed within the database
          schema_name = dsl_reader.schema_name

          # update the dynamic documentation
          description <<~DESCRIPTION
            Update the #{dsl_reader.server_type} server named `#{dsl_reader.server_name}`
            within DynamicMigrations. Create a table named `#{schema_name}`.`#{table_name}` within
            the #{dsl_reader.has_database_name? ? "`#{dsl_reader.database_name}`" : "default"} database.
          DESCRIPTION

          # Use the schema_name value which
          # object, this structure object comes from DynamicMigrations.
          schema = if database_structure.has_configured_schema? schema_name
            database_structure.configured_schema schema_name
          else
            database_structure.add_configured_schema schema_name
          end

          table_structure = schema.add_table table_name

          # add this child_class and table_strcuture pair to the
          # ModelToTableStructure class, this will provide faster
          # retrieval for the other migration composers
          ModelToTableStructure.add child_class, table_structure
        end
      end
    end
  end
end
