# frozen_string_literal: true

require "spec_helper"

RSpec.describe Platformer::Composers::GraphQL::Schema::Fields::Text do
  describe "for a new UserModel which defines a simple new model with a text field" do
    before(:each) do
      create_class "Users::UserModel", Platformer::BaseModel do
        text_field :my_text
      end
      create_class "Users::UserSchema", Platformer::BaseSchema do
        fields [
          :my_text
        ]
      end
    end

    after(:each) do
      destroy_class Types::Users::User
    end

    it "creates the expected GraphQL Type class" do
      # now that the UserModel has been created, we rerun the composer
      Platformer::Composers::GraphQL::Schema::CreateTypes.rerun
      Platformer::Composers::GraphQL::Schema::Fields::Text.rerun

      expect(Types::Users::User.fields["myText"]).to be_a GraphQL::Schema::Field

      expect(Types::Users::User.fields["myText"].type).to be_a GraphQL::Schema::NonNull
      expect(Types::Users::User.fields["myText"].type.of_type).to eq GraphQL::Types::String
    end
  end
end
