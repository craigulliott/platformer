# frozen_string_literal: true

require "spec_helper"

RSpec.describe Platformer::Composers::GraphQL::Schema::RootNode do
  let(:pg_helper) { RSpec.configuration.pg_spec_helper }

  describe "for a new UserModel which defines a simple new model with an integer field" do
    before(:each) do
      recreate_graphql_schema

      # create the postgres table
      pg_helper.create_model :public, :users do
        add_column :my_integer, :integer
      end

      # define the platform model for this user
      create_class "Users::UserModel", PlatformModel do
        database :postgres, :primary
        integer_field :my_integer
      end

      # define the graphql schema for this user
      create_class "Users::UserSchema", PlatformSchema do
        # root node causes this to be added as a root level query in the schema
        root_node do
          by_id
        end

        # name this model `user` instead of `users_user`
        suppress_namespace

        # expose the my_integer field
        fields [
          :my_integer
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
      Platformer::Composers::GraphQL::Schema::Fields::Integer.rerun
      Platformer::Composers::GraphQL::Schema::RootNode.rerun

      Schema.initialize_all

      user = Users::User.create! my_integer: 123

      results = Schema.execute <<~QUERY
        {
          user(id: "#{user.id}") {
            myInteger
          }
        }
      QUERY

      expect(results["data"]["user"]["myInteger"]).to eq 123
    end
  end
end
