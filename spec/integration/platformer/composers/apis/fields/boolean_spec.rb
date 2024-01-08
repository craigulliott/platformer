# frozen_string_literal: true

require "spec_helper"

RSpec.describe Platformer::Composers::API::Fields::Boolean do
  describe "for a new UserModel which defines a simple new model with a boolean field" do
    before(:each) do
      scaffold do
        model_for "Users::User" do
          database :postgres, :primary
          boolean_field :my_boolean
        end
        api_for "Users::User" do
          fields [
            :my_boolean
          ]
        end
      end
    end

    subject {
      Serializers::Users::User.attributes_map
    }

    context "adds the expected serializer attribute method" do
      it { expect(subject).to have_key :my_boolean }
    end
  end
end
