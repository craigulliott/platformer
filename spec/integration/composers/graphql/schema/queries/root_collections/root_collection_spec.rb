# frozen_string_literal: true

require "spec_helper"

RSpec.describe Platformer::Composers::GraphQL::Schema::Queries::RootCollection do
  describe "for a User model with a char_field that is exposed as a root collection" do
    before(:each) do
      scaffold do
        table_for "Users::User" do
          add_column :my_char, :char
        end

        model_for "Users::User" do
          database :postgres, :primary
          schema :users
          char_field :my_char
          # name this model `user` instead of `users_user`
          suppress_namespace
        end

        schema_for "Users::User" do
          # root node causes this to be added as a root level query in the schema
          root_collection do
            by_exact_string :my_char
          end
          # expose the my_char field
          fields [
            :my_char
          ]
        end
      end
    end

    it "executes an appropriate query successfully" do
      Users::User.create! my_char: "a"
      Users::User.create! my_char: "b"
      Users::User.create! my_char: "c"

      results = Schema.execute <<~QUERY
        {
          users(myChar: "a") {
            nodes {
              myChar
            }
          }
        }
      QUERY

      expect(results["data"]["users"]["nodes"].map { |u| u["myChar"] }).to eql ["a"]
    end

    it "executes an appropriate query with edges successfully" do
      Users::User.create! my_char: "a"
      Users::User.create! my_char: "b"
      Users::User.create! my_char: "c"

      results = Schema.execute <<~QUERY
        {
          users(myChar: "a") {
            edges {
              node {
                myChar
              }
            }
          }
        }
      QUERY

      expect(results["data"]["users"]["edges"].map { |u| u["node"]["myChar"] }).to eql ["a"]
    end
  end
end
