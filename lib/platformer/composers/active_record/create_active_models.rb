# frozen_string_literal: true

module Platformer
  module Composers
    module ActiveRecord
      # Create ActiveRecord classes to represent each of our model definitions.
      #
      # For example, if we have created a UserModel and an OrganizationModel
      # which extend BaseModel, then this composer will generate a `User`
      # and an `Organization` class which are extended from ActiveRecord::Base
      class CreateActiveModels < Parsers::AllModels
        # Process the parser for every decendant of BaseModel
        for_models do |model_definition_class:|
          add_documentation <<~DESCRIPTION
            Create an ActiveRecord class which corresponds to this model class.
          DESCRIPTION

          subclasses = ClassMap.subclasses(model_definition_class)
          has_subclasses = subclasses.count > 0

          if has_subclasses
            add_documentation <<~DESCRIPTION
              Because this model class is subclassed by #{subclasses.count}
              other classes including `#{subclasses.first.name}` the corresponding
              ActiveRecord class will be marked as abstract with `self.abstract_class = true`
            DESCRIPTION
          end

          # Get the ActiveRecord class which this new ActiveRecord cass should extend from
          #
          # For example...
          #
          # class UsersModel < BaseModel
          # end
          #
          # class AdminModel < UsersModel
          # end
          #
          # With the model class hieracy above, the expected base_classes are:
          #   base_class for AdminModel is UsersModel
          #   base_class for UsersModel is BaseModel
          #   base_class for BaseModel is ApplicationRecord
          base_class = if model_definition_class.ancestors[1] == BaseModel
            ApplicationRecord
          else
            # return the active_record class which was already created for this
            # models direct ancestor
            model_definition_class.ancestors[1].active_record_class
          end

          active_record_class = ClassMap.create_class model_definition_class.name.gsub(/Model\z/, ""), base_class do
            # if the model has subclasses, then this is an abstract class
            if has_subclasses
              self.abstract_class = true
            end
          end

          # make the database connections, and set the desired schemas
          for_dsl :database do |server_type:, server_name:, database_name:|
            add_documentation <<~DESCRIPTION
              Configure and connect to the `#{server_name}` #{server_type} server
              and the #{database_name.nil? ? "default" : database_name} database.
            DESCRIPTION

            # set up the request database connection for this class
            server = Databases.server(server_type, server_name)
            # if no database name was provided, then use the default database
            db = database_name.nil? ? server.default_database : server.database(database_name)
            active_record_class.establish_connection(db.active_record_configuration)
          end

          # set the desired postgres schema for models which extend this model
          for_dsl :schema do |schema_name:|
            add_documentation <<~DESCRIPTION
              Configure the ActiveRecord class to use the `#{schema_name}` database schema
              for this model by setting `table_name_prefix` to `#{schema_name}.`.
            DESCRIPTION

            active_record_class.table_name_prefix = "#{schema_name}."
          end
        end
      end
    end
  end
end
