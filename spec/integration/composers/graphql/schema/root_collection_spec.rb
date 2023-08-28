# frozen_string_literal: true

require "spec_helper"

RSpec.describe Platformer::Composers::GraphQL::Schema::RootCollection do
  let(:pg_helper) { RSpec.configuration.pg_spec_helper }

  describe "for a new UserModel which defines a simple new model with a char field" do
    before(:each) do
      recreate_graphql_schema

      # create the postgres table
      pg_helper.create_model :public, :users do
        add_column :my_char, :char
      end

      # define the platform model for this user
      create_class "Users::UserModel", PlatformModel do
        database :postgres, :primary
        char_field :my_char
      end

      # define the graphql schema for this user
      create_class "Users::UserSchema", PlatformSchema do
        # root node causes this to be added as a root level query in the schema
        root_collection do
          by_exact_string :my_char
        end

        # name this model `user` instead of `users_user`
        suppress_namespace

        # expose the my_char field
        fields [
          :my_char
        ]
      end
    end

    after(:each) do
      destroy_class Users::User
      destroy_class Types::Users::User
    end

    it "executes an appropriate query successfully" do
      # now that the UserModel has been created, we rerun the composers
      Platformer::Composers::ActiveRecord::CreateActiveModels.rerun
      Platformer::Composers::GraphQL::Schema::CreateTypes.rerun
      Platformer::Composers::GraphQL::Schema::Fields::Char.rerun
      Platformer::Composers::GraphQL::Schema::RootCollection.rerun

      Schema.initialize_all

      Users::User.create! my_char: "a"
      Users::User.create! my_char: "b"
      Users::User.create! my_char: "c"

      results = Schema.execute <<~QUERY
        {
          users(myChar: "a") {
            myChar
          }
        }
      QUERY

      expect(results["data"]["users"].map { |u| u["myChar"] }).to eql ["a"]
    end
  end
end
