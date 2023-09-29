# frozen_string_literal: true

require "spec_helper"

RSpec.describe Platformer::Composers::GraphQL::Mutations::Creators do
  describe "for a User model with an integer_field that has a creation mutation" do
    before(:each) do
      scaffold do
        table_for "User" do
          add_column :my_integer, :integer
        end

        model_for "User" do
          database :postgres, :primary
          integer_field :my_integer, allow_null: true do
            validate_less_than 200
          end
        end

        mutation_for "User" do
          # a mutation to create this model
          create do
            fields [:my_integer]
          end
        end

        schema_for "User" do
          # a schema to create this model
          fields [:my_integer]
        end
      end
    end

    it "executes an appropriate query successfully" do
      results = Schema.execute <<~QUERY
        mutation {
          createUser(
            input: {
              myInteger: 123
            }
          ) {
            errors {
              path
              message
            }
            user {
              myInteger
            }
          }
        }
      QUERY

      expect(results["data"]["createUser"]["user"]["myInteger"]).to eq 123
      expect(results["data"]["createUser"]["errors"]).to eql []

      user = User.find_by! my_integer: 123
      expect(user.my_integer).to eq 123
    end

    it "handles errors as expected when we pass a value of myInteger which exceeds the max permitted value" do
      results = Schema.execute <<~QUERY
        mutation {
          createUser(
            input: {
              myInteger: 200
            }
          ) {
            errors {
              path
              message
            }
            user {
              myInteger
            }
          }
        }
      QUERY

      expect(results["data"]["createUser"]["errors"]).to eql [
        {
          "path" => ["attributes", "myInteger"],
          "message" => "must be less than 200"
        }
      ]
    end
  end
end
