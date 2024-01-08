# frozen_string_literal: true

require "spec_helper"

RSpec.describe Platformer::Composers::API::Fields::Country do
  describe "for a new UserModel which defines a simple new model with a country field" do
    before(:each) do
      scaffold do
        model_for "Users::User" do
          database :postgres, :primary
          country_field
        end
        api_for "Users::User" do
          fields [
            :country,
            :country_code,
            :country_alpha3_code,
            :country_name,
            :country_full_name,
            :country_subregion,
            :country_continent
          ]
        end
      end
    end

    subject {
      Serializers::Users::User.attributes_map
    }

    context "country" do
      it { expect(subject).to have_key :country }
    end

    context "country code" do
      it { expect(subject).to have_key :country_code }
    end

    context "country alpha3 code" do
      it { expect(subject).to have_key :country_alpha3_code }
    end

    context "country name" do
      it { expect(subject).to have_key :country_name }
    end

    context "country full name" do
      it { expect(subject).to have_key :country_full_name }
    end

    context "country subregion" do
      it { expect(subject).to have_key :country_subregion }
    end

    context "country continent" do
      it { expect(subject).to have_key :country_continent }
    end
  end
end
