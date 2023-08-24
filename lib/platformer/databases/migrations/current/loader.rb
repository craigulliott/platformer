# frozen_string_literal: true

module Platformer
  module Databases
    class Migrations
      class Current
        # Loads the current migrations from disk and creates a Migration object for each one
        class Loader
          class UnexpectedMigrationFile < StandardError
          end

          MIGRATION_PATH_REGEX = /
            \A # start of string
            \/(?<type>[a-z_]+)
            \/(?<server_name>[a-z_]+)
            \/(?<database_name>[a-z_]+)
            (?<optional_schema>\/(?<schema_name>[a-z_]+))? # schema is optional
            \/(?<timestamp>\d{14})
            _(?<name>[a-z_]+)
            \.rb
            \z # end of string
          /x

          def initialize base_path
            @base_path = Pathname.new(base_path)
          end

          # return the migrations as a hash with the timestamp as the key
          def migrations
            results = Dir[@base_path + "**/*.rb"].map do |f|
              folder_and_file_name = f.delete_prefix(@base_path.to_s)
              if (matches = folder_and_file_name.match(MIGRATION_PATH_REGEX))
                MigrationFile.new(
                  base_path: @base_path,
                  type: matches[:type].to_sym,
                  server_name: matches[:server_name].to_sym,
                  database_name: matches[:database_name].to_sym,
                  schema_name: matches[:schema_name]&.to_sym,
                  timestamp: matches[:timestamp].to_i,
                  name: matches[:name].to_sym
                )
              else
                raise UnexpectedMigrationFile, "Unexpected migration file: #{folder_and_file_name} (does not match expected folder and filename pattern)"
              end
            end
            # return the migrations sorted by timestamp
            results.sort_by { |migration| migration.timestamp }
          end
        end
      end
    end
  end
end
