# frozen_string_literal: true

require "spec_helper"

RSpec.describe Platformer::Composers::GraphQL::Schema::CreateTypes do
  describe "for a new UserModel which defines a simple new model with an associated schema" do
    before(:each) do
      scaffold do
        model_for "Users::User" do
          database :postgres, :primary
        end
        schema_for "Users::User" do
        end
      end
    end

    it "creates the expected GraphQL Type class" do
      expect(Types::Users::User < Types::BaseObject).to be true
    end
  end
end
