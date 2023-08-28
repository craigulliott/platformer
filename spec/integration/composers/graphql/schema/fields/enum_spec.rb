# frozen_string_literal: true

require "spec_helper"

RSpec.describe Platformer::Composers::GraphQL::Schema::Fields::Enum do
  describe "for a new UserModel which defines a simple new model with an enum field" do
    before(:each) do
      create_class "Users::UserModel", PlatformModel do
        enum_field :my_enum, ["foo", "bar"]
      end
      create_class "Users::UserSchema", PlatformSchema do
        fields [
          :my_enum
        ]
      end
    end

    after(:each) do
      destroy_class Types::Users::User
    end

    it "creates the expected GraphQL Type class" do
      # now that the UserModel has been created, we rerun the composer
      Platformer::Composers::GraphQL::Schema::CreateTypes.rerun
      Platformer::Composers::GraphQL::Schema::Fields::Enum.rerun

      expect(Types::Users::User.fields["myEnum"]).to be_a GraphQL::Schema::Field

      expect(Types::Users::User.fields["myEnum"].type).to be_a GraphQL::Schema::NonNull
      expect(Types::Users::User.fields["myEnum"].type.of_type).to eq GraphQL::Types::String
    end
  end
end
