module Platformer
  module DSLs
    module Models
      module PostgresConnection
        def self.included klass
          klass.define_dsl :use_postgres_database do
            description <<-DESCRIPTION

            DESCRIPTION

            requires :configuration_name, :symbol do
              description <<-DESCRIPTION
                The name of the database connection to use
              DESCRIPTION
            end

            optional :database, :symbol do
              description <<-DESCRIPTION
                The name of the database
              DESCRIPTION
            end
          end

          klass.define_dsl :schema do
            description <<-DESCRIPTION

            DESCRIPTION

            requires :schema_name, :symbol do
              description <<-DESCRIPTION
                The name of the database connection to use
              DESCRIPTION
            end
          end
        end
      end
    end
  end
end
