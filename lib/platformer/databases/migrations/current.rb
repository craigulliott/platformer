# frozen_string_literal: true

module Platformer
  module Databases
    class Migrations
      # a list of all the current migrations, this class checks for
      # duplicates and is responsible for adding newly generated
      # migrations to the list, and saving them to disk
      class Current
        class DuplicateMigrationTimestampError < StandardError
        end

        class DuplicateMigrationNameError < StandardError
        end

        def initialize base_path
          @base_path = base_path

          # We store the migrations in a hash keyed by timestamp so that we can assert
          # that there are no duplicate timestamps.
          @migrations_by_timestamp = {}

          # We also store the migrations in a hash keyed by name and path so that we can
          # assert there are no duplicate names within each schema. The stricture of this
          # hash is:
          # {
          #   postgres: {
          #     server_name: {
          #       database_name: {
          #         schema_name: {
          #           name: Migration
          #         }
          #       }
          #     }
          #   }
          # }
          @migrations_by_name = {}

          # load from disk and add each of the current migrations
          Loader.new(base_path).migrations.each do |migration|
            add_migration migration
          end
        end

        # create a new migration file on disk and add it to the list of current migrations
        def create_migration type:, server_name:, database_name:, schema_name:, name:, contents: nil
          # generate a name for this migration, if the name already exists, then a sequential number will be added
          migration_name = generate_name type, server_name, database_name, schema_name, name

          # the timestamp of this new migration must be after (later than) the most recent migration
          migration = MigrationFile.new(
            base_path: @base_path,
            type: type,
            server_name: server_name,
            database_name: database_name,
            schema_name: schema_name,
            timestamp: generate_timestamp,
            name: migration_name
          )

          # add the migration to the internal representation of current migrations
          # this will assert the expected order of migrations, that the timestamp is
          # unique globally and that the name is unique within the schema
          add_migration migration

          # write the file to disk (this will raise an error if the file already exists)
          migration.create_file contents

          # return the new migration object
          migration
        end

        # returns an array of all the current migrations in order of their timestamp
        def migrations
          @migrations_by_timestamp.values
        end

        private

        # generate and return the current (or next available) timestamp
        def generate_timestamp
          timestamp = Time.now.strftime("%Y%m%d%H%M%S").to_i
          # sometimes we generate multiple migrations within the same second, if the timestamp is
          # less than the most recent, then take the most recent and add 1
          if timestamp <= most_recent_timestamp
            most_recent_timestamp + 1
          else
            timestamp
          end
        end

        # returns the timestamp of the newest / most recent migration
        # if there are no migrations, then return 0
        def most_recent_timestamp
          @migrations_by_timestamp.keys.last || 0
        end

        # Generate and return the current (or next available) migration name.
        # If a migration name is not unique within the schema, then a sequential number
        # will be appended.
        def generate_name type, server_name, database_name, schema_name, name
          i = nil
          while migration_name_exists? type, server_name, database_name, schema_name, :"#{name}#{i}"
            i = i.nil? ? 1 : i + 1
          end
          :"#{name}#{i}"
        end

        # add the migration to this objects internal representation of current migrations
        # this will add it to both the migrations_by_timestamp and migrations_by_name hashes
        def add_migration migration
          add_migration_by_timestamp migration
          add_migration_by_name_and_path migration

          migration
        end

        # add the migrations object to a hash keyed by timestamp, migrations must be added in
        # order of their timestamp, with the oldest migration first, this method will raise
        # an error if migrations are added in the wrong order, or if a duplicate timestamp is found
        def add_migration_by_timestamp migration
          # timestamp must be unique
          if @migrations_by_timestamp.key? migration.timestamp
            raise DuplicateMigrationTimestampError, "Duplicate migration timestamp: `#{migration.timestamp}` found when processing `#{migration.name}`"
          end

          # timestamp must be greater than the previous timestamp
          if migration.timestamp < most_recent_timestamp
            raise InvalidMigrationOrderError, "Migrations must be added in order. The timestamp of migration `#{migration.name}` is `#{migration.timestamp}` and the most recently added migration has a timestamp of `#{most_recent_timestamp}`"
          end

          # add the migration to the list
          @migrations_by_timestamp[migration.timestamp] = migration

          migration
        end

        def add_migration_by_name_and_path migration
          # if this is the first time we've seen this migration type, then
          # create the object to hold the migrations for this type
          type_migrations = @migrations_by_name[migration.type] ||= {}
          # if this is the first time we've seen this server
          server_migrations = type_migrations[migration.server_name] ||= {}
          # if this is the first time we've seen this database
          database_migrations = server_migrations[migration.database_name] ||= {}
          # if this is the first time we've seen this schema
          schema_migrations = database_migrations[migration.schema_name] ||= {}

          # name must be unique within this schema
          if schema_migrations.key? migration.name
            raise DuplicateMigrationNameError, "Duplicate migration name: `#{migration.name}` found when processing `#{migration.name}`"
          end

          # add the migration to the list
          schema_migrations[migration.name] = migration

          migration
        end

        # returns true if a migration with the provided path and name already exists
        def migration_name_exists? type, server_name, database_name, schema_name, name
          (@migrations_by_name[type] &&
            @migrations_by_name[type][server_name] &&
            @migrations_by_name[type][server_name][database_name] &&
            @migrations_by_name[type][server_name][database_name][schema_name] &&
            @migrations_by_name[type][server_name][database_name][schema_name][name]) ? true : false
        end
      end
    end
  end
end
