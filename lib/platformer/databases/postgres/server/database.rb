# frozen_string_literal: true

module Platformer
  module Databases
    module Postgres
      class Server
        class Database
          attr_reader :name
          attr_reader :server

          class MissingDatabaseNameError < StandardError
          end

          class UnexpectedFunctionError < StandardError
          end

          class UnexpectedConstantError < StandardError
          end

          def initialize server, name
            raise MissingDatabaseNameError if name.nil?

            @server = server
            @name = name.to_sym

            # add the default database to the structure
            @server.structure.add_database @name

            # ensure we have the default extensions installed
            structure.add_configured_extension :plpgsql
            structure.add_configured_extension :"uuid-ossp"
          end

          def structure
            @server.structure.database @name
          end

          # returns a reference to a shared postgres function, the first time
          # the function is referenced it will be created
          warn "not tested"
          def find_or_create_shared_function function_class
            unless function_class < Composers::Migrations::Functions::Function
              raise UnexpectedFunctionError, function_class
            end

            function_name = function_class.function_name

            # if the function has not already been installed, then install it now
            unless platformer_schema.has_function?(function_name)
              platformer_schema.add_function function_name, function_class.definition, description: function_class.description
            end

            # return the function structure object
            platformer_schema.function function_name
          end

          # returns the name to a shared enum type (such as currency_code or language_code)
          # which is stored in the platformer schema
          warn "not tested"
          def find_or_create_shared_enum constant_class
            unless constant_class < Constants::Constant
              raise UnexpectedConstantError, constant_class
            end

            enum_name = constant_class.constant_name

            # if the enum has not already been installed, then install it now
            unless platformer_schema.has_enum?(enum_name)
              platformer_schema.add_enum enum_name, constant_class.values, description: constant_class.description
            end

            # return the fully qualified enum name
            :"platformer.#{enum_name}"
          end

          # ensure we have a provided extensions installed into the provided database
          warn "not tested"
          def ensure_postgres_extension extension_name
            unless structure.has_configured_extension? extension_name
              structure.add_configured_extension extension_name
            end
          end

          warn "not tested"
          def platformer_schema
            @platformer_schema ||= get_platformer_schema_structure
          end

          # return the required configuration to create an active record connection with
          # this database
          def active_record_configuration
            {
              host: @server.host,
              port: @server.port,
              username: @server.username,
              password: @server.password,
              database: @name.to_s,
              encoding: "utf8",
              adapter: "postgis",
              schema_search_path: "public,postgis"
            }
          end

          # return the required configuration to create a pg connection with
          # this database
          def pg_configuration
            {
              host: @server.host,
              port: @server.port,
              username: @server.username,
              password: @server.password,
              database: @name
            }
          end

          private

          def get_platformer_schema_structure
            # shared enums are stored in the dedicated platformer schema
            unless structure.has_configured_schema?(:platformer)
              structure.add_configured_schema :platformer
            end
            # return the schema
            structure.configured_schema(:platformer)
          end
        end
      end
    end
  end
end
