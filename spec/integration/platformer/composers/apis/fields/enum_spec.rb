# frozen_string_literal: true

require "spec_helper"

RSpec.describe Platformer::Composers::API::Fields::Enum do
  describe "for a new UserModel which defines a simple new model with an enum field" do
    before(:each) do
      scaffold do
        model_for "Users::User" do
          database :postgres, :primary
          enum_field :my_enum, ["foo", "bar"]
        end
        api_for "Users::User" do
          fields [
            :my_enum
          ]
        end
      end
    end

    subject {
      Serializers::Users::User.attributes_map
    }

    context "adds the expected serializer attribute method" do
      it { expect(subject).to have_key :my_enum }
    end
  end
end
