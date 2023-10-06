# frozen_string_literal: true

module Platformer
  module Composers
    module ActiveRecord
      # Create ActiveRecord classes to represent each of our model definitions.
      #
      # For example, if we have created a UserModel and an OrganizationModel
      # which extend BaseModel, then this composer will generate a `User`
      # and an `Organization` class which are extended from ActiveRecord::Base
      class CreateActiveModels < Parsers::Models
        # Process the parser for every decendant of BaseModel
        for_models include_schema_base_classes: true, include_sti_classes: true do |is_schema_base_class:, model_definition_class:|
          add_documentation <<~DESCRIPTION
            Create an ActiveRecord class which corresponds to this model class.
          DESCRIPTION

          sti_class = model_definition_class.name.split("::").count == 3

          # the class name which will be used for this new active record class, this is
          # just the model class name without the word "Model" at the end.
          # the definition `Users::AvatarModel` results in an active record class `Users::Avatar`
          class_name = model_definition_class.name.gsub(/Model\z/, "")

          class_name = "#{class_name}Record" if is_schema_base_class

          # Each schema should have a dedicated class of each type which all other classes
          # of this type will extend from. For example, the users schema should have a class
          # named `Users::UsersModel` which extends `PlatformModel`, all models within the users
          # schema must then extend from this `Users::UsersModel`.
          #
          # This special base class should be created as an ActiveRecord abstract class.
          schema_name = model_definition_class.name.split("::").first

          # Get the ActiveRecord class which this new ActiveRecord class should extend from
          #
          # For example...
          # class `Communication::CommunicationModel` should extend `ApplicationRecord`
          # class `Communication::TemplateModel` should extend `Communication::Communication`
          # class `Communication::TextMessageModel` should extend `Communication::Communication`
          # class `Communication::TextMessages::WelcomeModel` is an STI class and
          # should extend `Communication::TextMessage`
          #
          # This hieracy is validated when the classes are built, so does not not
          # need to be validated here.
          base_class = if model_definition_class.ancestors[1] == PlatformModel
            ApplicationRecord

          elsif !is_schema_base_class && !sti_class
            "#{schema_name}::#{schema_name}Record".constantize

          else
            # return the active_record class which was already created for this
            # models direct ancestor
            model_definition_class.ancestors[1].active_record_class
          end

          active_record_class = ClassMap.create_class class_name, base_class do
            if is_schema_base_class
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
