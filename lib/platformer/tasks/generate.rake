require "platformer"
require "platformer/generators/all"

namespace :generate do
  desc "Generate boilerplate from a specific postgres database schema"
  task :from_db_schema, [:server_name, :database_name, :schema_name, :overwrite] do |t, args|
    # get the local database object which represents the requested database
    server = Platformer::Databases.server :postgres, args[:server_name].to_sym
    database = server.database args[:database_name].to_sym

    # connect to the database and load the structure
    database.structure.with_connection do |connection|
      database.structure.recursively_load_database_structure
    end

    # get the requested schema
    schema_name = args[:schema_name].to_sym
    schema = database.structure.loaded_schema(schema_name)

    # should the generator overwrite any existing files (default is to skip over these files)
    overwrite = args[:overwrite]&.to_s&.downcase == "true"

    # generate the platform files based on the contents of this postgres schema
    Platformer::Generators::FromDatabase::Generate.new(schema, overwrite).generate
  end

  desc <<~DESC
    Generate boilerplate from a specific postgres database (all schemas in the database).
    The last argment (schemas_to_skip) is optional, and you can overload the arguments with
    additional schemas to skip.
  DESC
  task :from_db, [:server_name, :database_name, :overwrite, :schemas_to_skip] do |t, args|
    # get the local database object which represents the requested database
    server = Platformer::Databases.server :postgres, args[:server_name].to_sym
    database = server.database args[:database_name].to_sym

    # connect to the database and load the structure
    database.structure.with_connection do |connection|
      database.structure.recursively_load_database_structure
    end

    # should the generator overwrite any existing files (default is to skip over these files)
    overwrite = args[:overwrite]&.to_s&.downcase == "true"

    # optionally skip some schemas (note, you can overload the argmetns with more schemas to skip)
    schema_names_to_skip = []
    schema_names_to_skip << args[:schemas_to_skip]&.to_sym if args[:schemas_to_skip]
    schema_names_to_skip += args.extras.map(&:to_sym) if args.extras.any?

    # process all the schemas in this database
    database.structure.loaded_schemas.each do |schema|
      next if schema_names_to_skip.include?(schema.name)

      # generate the platform files based on the contents of this postgres schema
      Platformer::Generators::FromDatabase::Generate.new(schema, overwrite).generate
    end
  end
end
