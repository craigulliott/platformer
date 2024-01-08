# frozen_string_literal: true

module Platformer
  module Generators
    module FromDatabase
      class Generate
        include Logger

        def initialize schema, overwrite
          @schema = schema
          @overwrite = overwrite
        end

        def generate
          log.info "Generating Models from postgres schema `#{@schema.name}`"
          generate_models

          log.info "Generating GraphQL Schemas from postgres schema `#{@schema.name}`"
          generate_graphql_schemas

          log.info "Completed Generation from postgres schema `#{@schema.name}`"
        end

        private

        def generate_models
          # the base class which all models in this schema extend from
          Models::BaseModel.new(@schema).write_to_file @overwrite
          #
          # generate the model for each table in this schema
          @schema.tables.each do |table|
            log.info "Processing table `#{table.schema.name}`.`#{table.name}`"

            Models::Model.new(table).write_to_file @overwrite
          end
        end

        def generate_graphql_schemas
          # todo
        end
      end
    end
  end
end
