# frozen_string_literal: true

require "spec_helper"

RSpec.describe Platformer::Composers::GraphQL::Schema::Fields::Float do
  describe "for a new UserModel which defines a simple new model with a float field" do
    before(:each) do
      create_class "Users::UserModel", PlatformModel do
        float_field :my_float
      end
      create_class "Users::UserSchema", PlatformSchema do
        fields [
          :my_float
        ]
      end
    end

    after(:each) do
      destroy_class Types::Users::User
    end

    it "creates the expected GraphQL Type class" do
      # now that the UserModel has been created, we rerun the composer
      Platformer::Composers::GraphQL::Schema::CreateTypes.rerun
      Platformer::Composers::GraphQL::Schema::Fields::Float.rerun

      expect(Types::Users::User.fields["myFloat"]).to be_a GraphQL::Schema::Field

      expect(Types::Users::User.fields["myFloat"].type).to be_a GraphQL::Schema::NonNull
      expect(Types::Users::User.fields["myFloat"].type.of_type).to eq GraphQL::Types::Float
    end
  end
end
