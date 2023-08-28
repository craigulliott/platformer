# frozen_string_literal: true

require "spec_helper"

RSpec.describe Platformer::Composers::GraphQL::Schema::Fields::Date do
  describe "for a new UserModel which defines a simple new model with a date field" do
    before(:each) do
      create_class "Users::UserModel", PlatformModel do
        date_field :my_date
      end
      create_class "Users::UserSchema", PlatformSchema do
        fields [
          :my_date
        ]
      end
    end

    after(:each) do
      destroy_class Types::Users::User
    end

    it "creates the expected GraphQL Type class" do
      # now that the UserModel has been created, we rerun the composer
      Platformer::Composers::GraphQL::Schema::CreateTypes.rerun
      Platformer::Composers::GraphQL::Schema::Fields::Date.rerun

      expect(Types::Users::User.fields["myDate"]).to be_a GraphQL::Schema::Field

      expect(Types::Users::User.fields["myDate"].type).to be_a GraphQL::Schema::NonNull
      expect(Types::Users::User.fields["myDate"].type.of_type).to eq GraphQL::Types::ISO8601Date
    end
  end
end
