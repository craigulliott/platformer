# frozen_string_literal: true

require "spec_helper"

RSpec.describe Platformer::Composers::Presenters::Fields::Country do
  describe "for a new UserModel which defines a simple new model with a country field" do
    before(:each) do
      scaffold do
        table_for "Users::User" do
          add_column :country, :char
        end
        model_for "Users::User" do
          database :postgres, :primary
          schema :users
          country_field
        end
      end
    end

    subject {
      user = Users::User.new(country: "COUNTRY_US")
      Presenters::Users::User.new user
    }

    context "creates the expected Presenter class" do
      it { expect(subject).to be_a Presenters::Base }

      it { expect(subject.country_name).to eq "United States of America" }

      it { expect(subject.country_full_name).to eq "The United States of America" }

      it { expect(subject.country_subregion).to eq "Northern America" }

      it { expect(subject.country_code).to eq "US" }

      it { expect(subject.country_alpha3_code).to eq "USA" }

      it { expect(subject.country_continent).to eq "North America" }
    end
  end
end
