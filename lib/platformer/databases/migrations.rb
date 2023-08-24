# frozen_string_literal: true

module Platformer
  module Databases
    class Migrations
      def initialize base_path
        @base_path = Pathname.new(base_path)
      end

      # Generate Migration objects from DynamicMigrations. These migrations would
      # bring all the current databases up to date with the configured structure.
      def generate_migration_files
        # load the current database structure into DynamicMigrations
        # this will ensure the generated migrations are based off the
        # most current real structure of the database
        load_database_structure

        # process each of the postgres servers
        Databases.servers(:postgres).each do |server|
          server.databases.each do |database|
            # generate all the required migrations for this database
            database.structure.differences.to_migrations.each do |migration|
              # create the Platformer migration file from the DynamicMigrations migration object
              current.create_migration type: :postgres,
                server_name: server.name,
                database_name: database.name,
                schema_name: migration[:schema_name],
                name: migration[:name],
                contents: migration[:content]
            end
          end
        end
      end

      private

      def current
        @current ||= Current.new(@base_path)
      end

      # Analyze the current databases and load the representation of their
      # structure into DynamicMigrations. This loaded structure will be compared
      # against the configured structure when generating the required migrations.
      def load_database_structure
        Databases.servers(:postgres).each do |server|
          server.databases.each do |database|
            database.structure.connect
            database.structure.recursively_load_database_structure
            database.structure.disconnect
          end
        end
      end
    end
  end
end
