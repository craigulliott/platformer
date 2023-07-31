module Platformer
  module DSLs
    module Models
      module Database
        def self.included klass
          klass.define_dsl :database do
            description <<-DESCRIPTION
              Selects the server, database and schema which will be
              used to store data for this model and all models which
              extend this one.

              All classes which extend the class where you use this DSL
              will inherit this configuration, you can call this method again
              on a decendent class and it will set the database configuration
              for only that class and any decendents of it.
            DESCRIPTION

            requires :server_type, :symbol do
              description <<-DESCRIPTION
                The type of this database, such as `postgres`

                This should correspond to a configuration block that is
                defined within `config/database.yaml`.
              DESCRIPTION

              validate_equal_to :postgres
            end

            requires :server_name, :symbol do
              description <<-DESCRIPTION
                The name of the database connection to use. This should
                be the name of a database configuration block that is
                defined within `config/database.yaml` and nested within
                a key which matches the server_type

                An example `config/database.yaml`

                ```yaml
                # This is the `server_type`, all postgres server configurations
                # are grouped together under this key.
                postgres:
                  # This is the `server_name`.
                  # You can define multiple postgres servers, you should
                  # use different configuration blocks for different servers,
                  # you do not have to create different configurations for
                  # multiple databases which reside on the same server.
                  my_database_server:
                    # This is the default database on the server, when you
                    # configure your models to use this server you can use
                    # either the default database or select another one that
                    # exists on this server.
                    default_database: database_name
                    username: craig
                    password:
                    host: localhost
                    port: 5432
                  my_other_database_server:
                    default_database: database_name
                    username: katy
                    password:
                    host: anotherhost
                    port: 5432
                ```

              DESCRIPTION
            end

            optional :database_name, :symbol do
              description <<-DESCRIPTION
                The name of the database which should be used on this
                server. If you do not provide a database name then
                then the default database for this server will be
                used.
              DESCRIPTION
            end
          end

          klass.define_dsl :schema do
            description <<-DESCRIPTION
              For databases which support it (such as `postgres`), this is the
              name of the postgres servers database schema where the data for
              this model will be persisted. If you do not provide a schema name,
              then the default schema (usually `public`) will be used.

              It is reccomended that all models which are within a namespace
              be placed in their own schema. For example.

              ```ruby
              # All of our model classes extend from PlatformModel.
              class PlatformModel
                # A default database server configuration for all models in
                # the platform to use
                # and the default database on that server
                database :postgres, :primary
              end

              # A base class within the Users namespace for all Users models
              # to extend from.
              class Users::UsersModel
                # all models within the Usrs namespace should be stored
                # in the "users" schema within our database
                schema :users

                # optionally, you could call `database` again here and it
                # would change the server and/or database which would be
                # used for only the models within the Users namespace
              end

              # Both of these models will be stored in the `users` schema
              # in our database (`users`.`users` and `users`.`avatars`).
              class Users:UserModel < UsersModel
                ...
              end
              class Users:AvatarModel < UsersModel
                ...
              end
              ````

            DESCRIPTION

            requires :schema_name, :symbol do
              description <<-DESCRIPTION
                The name of the schema to use.
              DESCRIPTION
            end
          end
        end
      end
    end
  end
end
