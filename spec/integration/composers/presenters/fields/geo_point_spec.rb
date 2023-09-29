# frozen_string_literal: true

require "spec_helper"

RSpec.describe Platformer::Composers::Presenters::Fields::GeoPoint do
  describe "for a new UserModel which defines a simple new model with a geo_point field" do
    before(:each) do
      scaffold do
        table_for "Users::User" do
          add_column :lonlat, :"postgis.geography(Point,4326)"
        end
        model_for "Users::User" do
          database :postgres, :primary
          schema :users
          geo_point_field
        end
      end
    end

    subject {
      user = Users::User.new(lonlat: "POINT (123.456 69.123)")
      Presenters::Users::User.new user
    }

    context "creates the expected Presenter class" do
      it { expect(subject).to be_a Presenters::Base }

      it { expect(subject.longitude).to eq 123.456 }

      it { expect(subject.latitude).to eq 69.123 }
    end
  end
end
