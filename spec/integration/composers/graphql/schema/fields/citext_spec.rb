# frozen_string_literal: true

require "spec_helper"

RSpec.describe Platformer::Composers::GraphQL::Schema::Fields::Citext do
  describe "for a new UserModel which defines a simple new model with a citext field" do
    before(:each) do
      create_class "Users::UserModel", Platformer::BaseModel do
        citext_field :my_citext
      end
      create_class "Users::UserSchema", Platformer::BaseSchema do
        fields [
          :my_citext
        ]
      end
    end

    after(:each) do
      destroy_class Types::Users::User
    end

    it "creates the expected GraphQL Type class" do
      # now that the UserModel has been created, we rerun the composer
      Platformer::Composers::GraphQL::Schema::CreateTypes.rerun
      Platformer::Composers::GraphQL::Schema::Fields::Citext.rerun

      expect(Types::Users::User.fields["myCitext"]).to be_a GraphQL::Schema::Field

      expect(Types::Users::User.fields["myCitext"].type).to be_a GraphQL::Schema::NonNull
      expect(Types::Users::User.fields["myCitext"].type.of_type).to eq GraphQL::Types::String
    end
  end
end
