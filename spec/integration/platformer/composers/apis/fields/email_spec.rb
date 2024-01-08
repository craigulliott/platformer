# frozen_string_literal: true

require "spec_helper"

RSpec.describe Platformer::Composers::API::Fields::Email do
  describe "for a new UserModel which defines a simple new model with an email field" do
    before(:each) do
      scaffold do
        model_for "Users::User" do
          database :postgres, :primary
          email_field name: :my_email
        end
        api_for "Users::User" do
          fields [
            :my_email
          ]
        end
      end
    end

    subject {
      Serializers::Users::User.attributes_map
    }

    context "adds the expected serializer attribute method" do
      it { expect(subject).to have_key :my_email }
    end
  end
end
