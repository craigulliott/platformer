# frozen_string_literal: true

require "fileutils"

module Platformer
  module Databases
    class Migrations
      class MigrationFile
        class MissingMigrationContentsError < StandardError
        end

        class MigrationFileAlreadyExistsError < StandardError
        end

        class MigrationFileDoesNotExist < StandardError
        end

        attr_reader :base_path
        attr_reader :type
        attr_reader :server_name
        attr_reader :database_name
        attr_reader :schema_name
        attr_reader :timestamp
        attr_reader :name

        def initialize base_path:, type:, server_name:, database_name:, schema_name:, timestamp:, name:
          @base_path = Pathname.new base_path
          @type = type
          @server_name = server_name
          @database_name = database_name
          @schema_name = schema_name
          @timestamp = timestamp
          @name = name
        end

        # Asserts the file does not already exist, and then creates a new migration file
        # on disk. `contents` is the ruby syntax which will be written within
        # the `def change` method of the migration file. This method will automatically
        # wrap the provided contents within the class definition and the `def change` method.
        def create_file contents
          raise MigrationFileAlreadyExistsError if exists_on_disk?
          raise MissingMigrationContentsError if contents.nil?
          # ensure the file folder exists
          create_file_folders full_path
          # write the migration to disk
          if schema_name.nil?
            File.write(full_path, <<~RUBY)
              module Migrations
                module #{type.to_s.camelize}
                  module #{server_name.to_s.camelize}
                    module #{database_name.to_s.camelize}
                      class #{name.to_s.camelize} < ::Platformer::Databases::Migration
                        def change
                          #{contents.gsub("\n", "\n              ")}
                        end
                      end
                    end
                  end
                end
              end
            RUBY
          else
            File.write(full_path, <<~RUBY)
              module Migrations
                module #{type.to_s.camelize}
                  module #{server_name.to_s.camelize}
                    module #{database_name.to_s.camelize}
                      module #{schema_name.to_s.camelize}
                        class #{name.to_s.camelize} < ::Platformer::Databases::Migration
                          def change
                            #{contents.gsub("\n", "\n              ")}
                          end
                        end
                      end
                    end
                  end
                end
              end
            RUBY
          end
        end

        # return the contents of the file, raises an error
        # if the file does not exist
        def contents
          unless exists_on_disk?
            raise MigrationFileDoesNotExist, full_path
          end
          # return the contents of the file
          File.read(full_path)
        end

        def migrate
          migration_class = get_class

          # set the current schema name so that migrations are run in the correct context
          unless schema_name.nil?
            migration_class.set_schema_name schema_name
            migration_class.schema_search_path = "#{schema_name},public"
          end

          # run the migrations
          migration_class.migrate(:up)
        end

        private

        def get_class
          require_file

          if schema_name.nil?
            "Migrations::#{type.to_s.camelize}::#{server_name.to_s.camelize}::#{database_name.to_s.camelize}::#{name.to_s.camelize}".constantize
          else
            "Migrations::#{type.to_s.camelize}::#{server_name.to_s.camelize}::#{database_name.to_s.camelize}::#{schema_name.to_s.camelize}::#{name.to_s.camelize}".constantize
          end
        end

        def require_file
          require_relative full_path
        end

        def exists_on_disk?
          File.exist? full_path
        end

        def create_file_folders full_path
          dirname = File.dirname(full_path)
          unless File.directory?(dirname)
            FileUtils.mkdir_p(dirname)
          end
        end

        def full_path
          Pathname.new(base_path) + relative_path
        end

        def relative_path
          if schema_name.nil?
            "./#{type}/#{server_name}/#{database_name}/#{timestamp}_#{name}.rb"
          else
            "./#{type}/#{server_name}/#{database_name}/#{schema_name}/#{timestamp}_#{name}.rb"
          end
        end
      end
    end
  end
end
