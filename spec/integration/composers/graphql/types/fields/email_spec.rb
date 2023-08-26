# frozen_string_literal: true

require "spec_helper"

RSpec.describe Platformer::Composers::GraphQL::Types::Fields::Email do
  describe "for a new UserModel which defines a simple new model with an integer field" do
    before(:each) do
      create_class "Users::UserModel", PlatformModel do
        email_field :my_email
      end
    end

    after(:each) do
      destroy_class Types::Users::User
    end

    it "creates the expected GraphQL Type class" do
      # now that the UserModel has been created, we rerun the composer
      Platformer::Composers::GraphQL::Types::CreateTypes.rerun
      Platformer::Composers::GraphQL::Types::Fields::Email.rerun

      expect(Types::Users::User.fields["myEmail"]).to be_a GraphQL::Schema::Field

      expect(Types::Users::User.fields["myEmail"].type).to be_a GraphQL::Schema::NonNull
      expect(Types::Users::User.fields["myEmail"].type.of_type).to eq GraphQL::Types::String
    end
  end
end
