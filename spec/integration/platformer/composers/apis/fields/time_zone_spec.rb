# frozen_string_literal: true

require "spec_helper"

RSpec.describe Platformer::Composers::API::Fields::TimeZone do
  describe "for a new UserModel which defines a simple new model with a time_zone field" do
    before(:each) do
      scaffold do
        model_for "Users::User" do
          database :postgres, :primary
          time_zone_field
        end
        api_for "Users::User" do
          fields [
            :time_zone,
            :time_zone_name,
            :time_zone_identifier
          ]
        end
      end
    end

    subject {
      Serializers::Users::User.attributes_map
    }

    context "time_zone" do
      it { expect(subject).to have_key :time_zone }
    end

    context "time_zone_name" do
      it { expect(subject).to have_key :time_zone_name }
    end

    context "time_zone_identifier" do
      it { expect(subject).to have_key :time_zone_identifier }
    end
  end
end
