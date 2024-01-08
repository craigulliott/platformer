# frozen_string_literal: true

require "spec_helper"

RSpec.describe Platformer::Composers::GraphQL::Mutations::Updaters do
  describe "for a User model with an enum that has an updater mutation" do
    before(:each) do
      scaffold do
        table_for "Users::User" do
          add_column :my_enum, :text
        end

        model_for "Users::User" do
          database :postgres, :primary
          schema :users
          # updateUser instead of updateUsersUser
          suppress_namespace
          enum_field :my_enum, ["VALUE1", "VALUE2"]
        end

        mutation_for "Users::User" do
          update do
            fields [:my_enum]
          end
        end

        schema_for "Users::User" do
          fields [:my_enum]
        end
      end
    end

    it "executes an appropriate query successfully" do
      user = Users::User.create! my_enum: "VALUE1"
      global_id = user.to_gid_param

      results = Schema.execute <<~QUERY
        mutation {
          updateUser(
            input: {
              id: "#{global_id}",
              myEnum: VALUE2
            }
          ) {
            errors {
              path
              message
            }
            user {
              myEnum
            }
          }
        }
      QUERY

      expect(results["data"]["updateUser"]["user"]["myEnum"]).to eq "VALUE2"
      expect(results["data"]["updateUser"]["errors"]).to eql []

      user.reload
      expect(user.my_enum).to eq "VALUE2"
    end
  end
end
