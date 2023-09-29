# frozen_string_literal: true

require "spec_helper"

RSpec.describe Platformer::Composers::Migrations::Columns::GeoPoint do
  describe "for a User Model which has a geo_point column named my_lonlat" do
    before(:each) do
      scaffold do
        model_for "Users::User" do
          database :postgres, :primary
          geo_point_field prefix: :my
        end
      end
    end

    subject {
      Platformer::Databases.server(:postgres, :primary).default_database.structure.configured_schema(:public).table(:users)
    }

    context "creates the expected columns within the DynamicMigrations table" do
      it { expect(subject.has_column?(:my_lonlat)).to be true }

      it { expect(subject.column(:my_lonlat).data_type).to be :"postgis.geography(Point,4326)" }

      it { expect(subject.column(:my_lonlat).null).to be false }

      it { expect(subject.column(:my_lonlat).description).to be_nil }

      it { expect(subject.column(:my_lonlat).default).to be_nil }
    end
  end

  describe "for a User Model which has a geo_point column named my_lonlat that has a default value, allows null and has a description" do
    before(:each) do
      scaffold do
        model_for "Users::User" do
          database :postgres, :primary
          geo_point_field prefix: :my, allow_null: true do
            description "This is a description"
            database_default "katy@socialkaty.com"
          end
        end
      end
    end

    subject {
      Platformer::Databases.server(:postgres, :primary).default_database.structure.configured_schema(:public).table(:users)
    }

    context "creates the expected columns within the DynamicMigrations table" do
      it { expect(subject.has_column?(:my_lonlat)).to be true }

      it { expect(subject.column(:my_lonlat).data_type).to be :"postgis.geography(Point,4326)" }

      it { expect(subject.column(:my_lonlat).null).to be true }

      it { expect(subject.column(:my_lonlat).description).to eq "This is a description" }

      it { expect(subject.column(:my_lonlat).default).to eq "katy@socialkaty.com" }
    end
  end

  describe "for a User Model with an array of geo_points column named my_lonlat" do
    before(:each) do
      scaffold do
        model_for "Users::User" do
          database :postgres, :primary
          geo_point_field prefix: :my, array: true
        end
      end
    end

    subject {
      Platformer::Databases.server(:postgres, :primary).default_database.structure.configured_schema(:public).table(:users)
    }

    context "creates the expected columns within the DynamicMigrations table" do
      it { expect(subject.has_column?(:my_lonlat)).to be true }

      it { expect(subject.column(:my_lonlat).data_type).to be :"postgis.geography(Point,4326)[]" }
    end
  end

  describe "for a User Model with an geo_points column without a custom name" do
    before(:each) do
      scaffold do
        model_for "Users::User" do
          database :postgres, :primary
          geo_point_field
        end
      end
    end

    subject {
      Platformer::Databases.server(:postgres, :primary).default_database.structure.configured_schema(:public).table(:users)
    }

    context "creates the expected columns within the DynamicMigrations table" do
      it { expect(subject.has_column?(:lonlat)).to be true }

      it { expect(subject.column(:lonlat).data_type).to be :"postgis.geography(Point,4326)" }
    end
  end
end
