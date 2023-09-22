require "platformer"
require "platformer/generators/all"

namespace :generate do
  desc "Generate boilerplate from a postgres database schema"
  task :from_db_schema, [:server_name, :database_name, :schema_name, :overwrite] do |t, args|
    # get the local database object which represents the requested database
    server = Platformer::Databases.server :postgres, args[:server_name].to_sym
    database = server.database args[:database_name].to_sym

    # connect to the database and load the structure
    database.structure.with_connection do |connection|
      database.structure.recursively_load_database_structure
    end

    schema = database.structure.loaded_schema(args[:schema_name].to_sym)

    # models
    #
    overwrite = args[:overwrite]&.to_s&.downcase == "true"

    # the base class which all models in this schema extend from
    Platformer::Generators::FromDatabase::BaseModel.new(schema).write_to_file overwrite

    # generate the model for each table in this schema
    schema.tables.each do |table|
      Platformer::Generators::FromDatabase::Model.new(table).write_to_file overwrite
    end
  end
end
