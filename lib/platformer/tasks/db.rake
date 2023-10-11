require "platformer"

namespace :db do
  desc "Create all the configured databases"
  task create_databases: :environment do
    Platformer::Databases.servers(:postgres).each do |server|
      server.with_connection do |connection|
        server.database_names.each do |database_name|
          # create the database using the connection to the server
          connection.exec <<~SQL
            CREATE DATABASE #{database_name} ENCODING 'utf8';
          SQL

          # open a connection to the new database (because we can't create
          # a schema from the databaseless server connection)
          server.database(database_name).with_connection do |connection|
            connection.exec <<~SQL
              CREATE SCHEMA platformer;
              CREATE SCHEMA IF NOT EXISTS public;
              CREATE SCHEMA dynamic_migrations;
            SQL
            # todo, remove this (below) once we have finished the codeverse migration
            # as this will typically be resolved much earlier in the definition
            # of your platform
            connection.exec <<~SQL
              -- postgis
              CREATE SCHEMA IF NOT EXISTS postgis;
              GRANT ALL ON SCHEMA postgis TO PUBLIC;
              CREATE EXTENSION IF NOT EXISTS postgis WITH SCHEMA postgis;
              -- citext
              CREATE EXTENSION IF NOT EXISTS citext SCHEMA public;
            SQL
          end
        end
      end
    end
  end

  desc "Drop all the configured databases"
  task drop_databases: :environment do
    Platformer::Databases.servers(:postgres).each do |server|
      server.with_connection do |connection|
        server.database_names.each do |database_name|
          # does the database exist
          rows = connection.exec <<~SQL
            SELECT 1 FROM pg_database WHERE datname = '#{database_name}';
          SQL
          # drop it
          if rows.count > 0
            connection.exec <<~SQL
              DROP DATABASE #{database_name};
            SQL
          end
        end
      end
    end
  end

  desc <<~DESC.strip
    Compare the structure of each configured database to the actual
    database structure and output the differences (JSON formatted)
  DESC
  task differences: :environment do
    differences = Platformer::Databases::Migrations.new(Platformer.root("db/migrations")).differences
    puts JSON.pretty_generate(differences)
  end

  desc <<~DESC.strip
    Compare the structure of each configured database to the actual
    database structure and dynamically generate migration files to
    resolve any differences
  DESC
  task generate_migrations: :environment do
    Platformer::Databases::Migrations.new(Platformer.root("db/migrations")).generate_migration_files
  end

  desc "Delete any migration files which have not been commited to git"
  task :delete_uncommited_migrations do
    Dir.chdir(Platformer.root(".")) do
      `git checkout db/migrations`
      `git clean -f db/migrations`
    end
  end

  desc "Execute any outstanding migrations files"
  task :migrate do
    Platformer::Databases::Migrations::Current.new(Platformer.root("db/migrations")).migrations.each do |migration|
      migration.migrate
    end
    Platformer::Databases.servers(:postgres).each do |server|
      server.databases.each do |database|
        database.structure.connect
        database.structure.refresh_caches
        database.structure.disconnect
      end
    end
  end

  desc <<~DESC.strip
    Perform several common development related database tasks in a single
    command (for development and testing environments only)
      * Delete any uncommited migration files
      * Drop and recreate the databases
      * Rebuild the databases using the commited/finalized migrations
      * Generate new migration files based on the difference between the
        configured database structure and the actual database structure
      * Migrate again to execute these newly generated migratons
  DESC
  task :dynamic_migrate do
    Rake::Task["db:delete_uncommited_migrations"].invoke
    Rake::Task["db:drop_databases"].invoke
    Rake::Task["db:create_databases"].invoke
    Rake::Task["db:migrate"].invoke
    Rake::Task["db:generate_migrations"].invoke
    # because rake tasks can't usually be run twice, we reenable it here so the dynamic_migrate task can run this twice
    Rake::Task["db:migrate"].reenable
    Rake::Task["db:migrate"].invoke
  end
end
