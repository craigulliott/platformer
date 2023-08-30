# frozen_string_literal: true

require "spec_helper"

RSpec.describe Platformer::Composers::GraphQL::Schema::CreateTypes do
  describe "for a new UserModel which defines a simple new model with an associated schema" do
    before(:each) do
      create_class "Users::UserModel", Platformer::BaseModel do
      end
      create_class "Users::UserSchema", Platformer::BaseSchema do
      end
    end

    after(:each) do
      destroy_class Types::Users::User
    end

    it "creates the expected GraphQL Type class" do
      # now that the UserModel has been created, we rerun the composer
      Platformer::Composers::GraphQL::Schema::CreateTypes.rerun

      expect(Types::Users::User < Types::BaseObject).to be true
    end
  end
end
