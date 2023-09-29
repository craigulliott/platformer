# frozen_string_literal: true

require "spec_helper"

RSpec.describe Platformer::Composers::Migrations::Columns::TimeZone do
  describe "for a User Model which has a time_zone field" do
    before(:each) do
      scaffold do
        model_for "Users::User" do
          database :postgres, :primary
          time_zone_field
        end
      end
    end

    subject {
      Platformer::Databases.server(:postgres, :primary).default_database.structure.configured_schema(:public).table(:users)
    }

    context "creates the expected columns within the DynamicMigrations table" do
      it { expect(subject.has_column?(:time_zone)).to be true }

      it { expect(subject.column(:time_zone).data_type).to be :"platformer.time_zone" }

      it { expect(subject.column(:time_zone).null).to be false }

      it { expect(subject.column(:time_zone).description).to be_nil }

      it { expect(subject.column(:time_zone).default).to be_nil }
    end
  end

  describe "for a User Model which has a time_zone field that has a default value, allows null and has a description" do
    before(:each) do
      scaffold do
        model_for "Users::User" do
          database :postgres, :primary
          time_zone_field allow_null: true do
            description "This is a description"
            database_default "America/Chicago"
          end
        end
      end
    end

    subject {
      Platformer::Databases.server(:postgres, :primary).default_database.structure.configured_schema(:public).table(:users)
    }

    context "creates the expected columns within the DynamicMigrations table" do
      it { expect(subject.has_column?(:time_zone)).to be true }

      it { expect(subject.column(:time_zone).data_type).to be :"platformer.time_zone" }

      it { expect(subject.column(:time_zone).null).to be true }

      it { expect(subject.column(:time_zone).description).to eq "This is a description" }

      it { expect(subject.column(:time_zone).default).to eq "America/Chicago" }
    end
  end

  describe "for a User Model with an array of time_zones" do
    before(:each) do
      scaffold do
        model_for "Users::User" do
          database :postgres, :primary
          time_zone_field array: true
        end
      end
    end

    subject {
      Platformer::Databases.server(:postgres, :primary).default_database.structure.configured_schema(:public).table(:users)
    }

    context "creates the expected columns within the DynamicMigrations table" do
      it { expect(subject.has_column?(:time_zone)).to be true }

      it { expect(subject.column(:time_zone).data_type).to be :"platformer.time_zone[]" }
    end
  end
end
