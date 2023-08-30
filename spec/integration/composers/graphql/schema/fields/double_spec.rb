# frozen_string_literal: true

require "spec_helper"

RSpec.describe Platformer::Composers::GraphQL::Schema::Fields::Double do
  describe "for a new UserModel which defines a simple new model with a double field" do
    before(:each) do
      create_class "Users::UserModel", Platformer::BaseModel do
        double_field :my_double
      end
      create_class "Users::UserSchema", Platformer::BaseSchema do
        fields [
          :my_double
        ]
      end
    end

    after(:each) do
      destroy_class Types::Users::User
    end

    it "creates the expected GraphQL Type class" do
      # now that the UserModel has been created, we rerun the composer
      Platformer::Composers::GraphQL::Schema::CreateTypes.rerun
      Platformer::Composers::GraphQL::Schema::Fields::Double.rerun

      expect(Types::Users::User.fields["myDouble"]).to be_a GraphQL::Schema::Field

      expect(Types::Users::User.fields["myDouble"].type).to be_a GraphQL::Schema::NonNull
      expect(Types::Users::User.fields["myDouble"].type.of_type).to eq GraphQL::Types::String
    end
  end
end
