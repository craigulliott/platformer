# frozen_string_literal: true

require "spec_helper"

RSpec.describe Platformer::Composers::GraphQL::Schema::CreateTypes do
  describe "for a new UserModel which defines a simple new model with an associated schema" do
    before(:each) do
      scaffold do
        model_for "Users::User" do
          database :postgres, :primary
          integer_field :my_integer
          schema :users
          # name this model `user` instead of `users_user`
          suppress_namespace
        end

        api_for "Users::User" do
          # expose a basic get endpoint for this resource
          get do
          end
        end
      end
    end

    it "creates the expected JSONAPI Serializer class" do
      expect(Serializers::Users::User < Serializers::Base).to be true
    end
  end
end
