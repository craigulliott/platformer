# frozen_string_literal: true

require "spec_helper"

RSpec.describe Platformer::Composers::GraphQL::Mutations::Updaters do
  describe "for a User model with an integer_field that has an updater mutation" do
    before(:each) do
      scaffold do
        table_for "User" do
          add_column :my_integer, :integer
        end

        model_for "User" do
          database :postgres, :primary
          integer_field :my_integer do
            allow_null
            validate_less_than 200
          end
        end

        mutation_for "User" do
          # a mutation to update this model
          update do
            fields [:my_integer]
          end
        end

        schema_for "User" do
          # a schema to update this model
          fields [:my_integer]
        end
      end
    end

    it "executes an appropriate query successfully" do
      user = User.create! my_integer: 10
      global_id = user.to_gid_param

      results = Schema.execute <<~QUERY
        mutation {
          updateUser(
            input: {
              id: "#{global_id}",
              myInteger: 100
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

      expect(results["data"]["updateUser"]["user"]["myInteger"]).to eq 100
      expect(results["data"]["updateUser"]["errors"]).to eql []

      user.reload
      expect(user.my_integer).to eq 100
    end

    it "handles errors as expected when we pass a value of myInteger which exceeds the max permitted value" do
      user = User.create! my_integer: 10
      global_id = user.to_gid_param

      results = Schema.execute <<~QUERY
        mutation {
          updateUser(
            input: {
              id: "#{global_id}",
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

      expect(results["data"]["updateUser"]["errors"]).to eql [
        {
          "path" => ["attributes", "myInteger"],
          "message" => "must be less than 200"
        }
      ]
    end
  end
end
