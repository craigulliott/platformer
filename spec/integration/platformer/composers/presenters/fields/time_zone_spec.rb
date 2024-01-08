# frozen_string_literal: true

require "spec_helper"

RSpec.describe Platformer::Composers::Presenters::Fields::TimeZone do
  describe "for a new UserModel which defines a simple new model with a time_zone field" do
    before(:each) do
      scaffold do
        table_for "Users::User" do
          add_column :time_zone, :char
        end
        model_for "Users::User" do
          database :postgres, :primary
          schema :users
          time_zone_field
        end
      end
    end

    subject {
      user = Users::User.new(time_zone: "TZ_AMERICA_CHICAGO")
      Presenters::Users::User.new user
    }

    context "creates the expected Presenter class" do
      it { expect(subject).to be_a Presenters::Base }

      it { expect(subject.time_zone).to eq "TZ_AMERICA_CHICAGO" }

      it { expect(subject.time_zone_name).to eq "Central Time (US & Canada)" }

      it { expect(subject.time_zone_identifier).to eq "America/Chicago" }
    end
  end
end
