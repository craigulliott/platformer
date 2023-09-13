require "platformer"

namespace :db do
  desc "Create all the configured databases"
  task :create_databases do
    Platformer::Databases.servers(:postgres).each do |server|
      server.with_connection do |connection|
        server.database_names.each do |database_name|
          connection.exec <<~SQL
            CREATE DATABASE #{database_name} ENCODING 'utf8';
          SQL
        end
      end
    end
  end

  desc "Drop all the configured databases"
  task :drop_databases do
    Platformer::Databases.servers(:postgres).each do |server|
      server.with_connection do |connection|
        server.database_names.each do |database_name|
          connection.exec <<~SQL
            DROP DATABASE #{database_name};
          SQL
        end
      end
    end
  end

  desc <<~DESC.strip
    Compare the structure of each configured database to the actual
    database structure and dynamically generate migration files to
    resolve any differences
  DESC
  task :generate_migrations do
    Platformer::Databases::Migrations.new(Platformer.root("db/migrations")).generate_migration_files
  end

  desc "Delete any migration files which have not been commited to git"
  task :delete_uncommited_migrations do
    Dir.chdir(Platformer.root) do
      `git checkout db/migrate`
      `git clean -f db/migrate`
    end
  end

  desc "Execute any outstanding migrations files"
  task :migrate do
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
  task dynamic_migrate: [:delete_uncommited_migrations, :drop_databases, :create_databases, :migrate, :generate_migrations, :migrate] do
    puts "Dynamic Migrations Complete"
  end
end
