# frozen_string_literal: true

require "spec_helper"

RSpec.describe Platformer::Composers::GraphQL::Schema::Queries::RootNode do
  describe "for a User model with an integer_field that is exposed as a root node" do
    before(:each) do
      scaffold do
        table_for "User" do
          add_column :my_integer, :integer
        end

        model_for "User" do
          database :postgres, :primary
          integer_field :my_integer
          # name this model `user` instead of `users_user`
          suppress_namespace
        end

        schema_for "User" do
          # root node causes this to be added as a root level query in the schema
          root_node do
            by_id
          end
          # expose the my_integer field
          fields [
            :my_integer
          ]
        end
      end
    end

    it "executes an appropriate query successfully" do
      user = User.create! my_integer: 123

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
