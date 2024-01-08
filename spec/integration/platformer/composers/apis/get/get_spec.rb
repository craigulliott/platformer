# frozen_string_literal: true

require "spec_helper"

RSpec.describe Platformer::Composers::API::Get do
  include Rack::Test::Methods

  def app
    Platformer::Server::Routes::JSONAPI
  end

  describe "for a User model with an integer_field that has a defined get endpoint" do
    before(:each) do
      scaffold do
        table_for "Users::User" do
          add_column :my_integer, :integer
        end

        model_for "Users::User" do
          database :postgres, :primary
          integer_field :my_integer
          schema :users
          primary_key
          # name this model `user` instead of `users_user`
          suppress_namespace
        end

        api_for "Users::User" do
          # the fields which are included in the serialized response
          fields [:my_integer]
          # expose a basic get endpoint for this resource
          get
        end
      end
    end

    let(:user) { Users::User.create! my_integer: 123 }

    it "returns the expected user" do
      get "/users/#{user.id}"

      expect(last_response.status).to eq(200)

      expect(JSON.parse(last_response.body)).to eql({
        "data" => {
          "type" => "users",
          "id" => user.id,
          "attributes" => {
            "my_integer" => 123
          },
          "links" => {
            "self" => "https://platformer.local/users/#{user.id}"
          },
          "meta" => {
            "deletable" => false
          }
        }
      })
    end
  end
end
