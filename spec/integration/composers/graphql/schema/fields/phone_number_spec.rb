# frozen_string_literal: true

require "spec_helper"

RSpec.describe Platformer::Composers::GraphQL::Schema::Fields::PhoneNumber do
  describe "for a new UserModel which defines a simple new model with a phone number field" do
    before(:each) do
      create_class "Users::UserModel", PlatformModel do
        phone_number_field :my_phone_number
      end
      create_class "Users::UserSchema", PlatformSchema do
        fields [
          :my_phone_number
        ]
      end
    end

    after(:each) do
      destroy_class Types::Users::User
    end

    it "creates the expected GraphQL Type class" do
      # now that the UserModel has been created, we rerun the composer
      Platformer::Composers::GraphQL::Schema::CreateTypes.rerun
      Platformer::Composers::GraphQL::Schema::Fields::PhoneNumber.rerun

      expect(Types::Users::User.fields["myPhoneNumber"]).to be_a GraphQL::Schema::Field

      expect(Types::Users::User.fields["myPhoneNumber"].type).to be_a GraphQL::Schema::NonNull
      expect(Types::Users::User.fields["myPhoneNumber"].type.of_type).to eq GraphQL::Types::String
    end
  end
end
