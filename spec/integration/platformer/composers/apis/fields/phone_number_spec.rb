# frozen_string_literal: true

require "spec_helper"

RSpec.describe Platformer::Composers::API::Fields::PhoneNumber do
  describe "for a new UserModel which defines a simple new model with a phone number field" do
    before(:each) do
      scaffold do
        model_for "Users::User" do
          database :postgres, :primary
          phone_number_field
        end
        api_for "Users::User" do
          fields [
            :phone_number,
            :dialing_code
          ]
        end
      end
    end

    subject {
      Serializers::Users::User.attributes_map
    }

    context "phone_number" do
      it { expect(subject).to have_key :phone_number }
    end

    context "dialing_code" do
      it { expect(subject).to have_key :dialing_code }
    end
  end
end
