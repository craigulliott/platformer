# frozen_string_literal: true

require "spec_helper"

RSpec.describe Platformer::Composers::API::Fields::IpAddress do
  describe "for a new UserModel which defines a simple new model with an ip_address field" do
    before(:each) do
      scaffold do
        model_for "Users::User" do
          database :postgres, :primary
          ip_address_field :my_ip_address
        end
        api_for "Users::User" do
          fields [
            :my_ip_address
          ]
        end
      end
    end

    subject {
      Serializers::Users::User.attributes_map
    }

    context "adds the expected serializer attribute method" do
      it { expect(subject).to have_key :my_ip_address }
    end
  end
end
