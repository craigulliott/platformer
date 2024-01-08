# frozen_string_literal: true

require "spec_helper"

RSpec.describe Platformer::Composers::Migrations::Columns::Country do
  describe "for a User Model which has a country field" do
    before(:each) do
      scaffold do
        model_for "Users::User" do
          database :postgres, :primary
          country_field
        end
      end
    end

    subject {
      Platformer::Databases.server(:postgres, :primary).default_database.structure.configured_schema(:public).table(:users)
    }

    context "creates the expected columns within the DynamicMigrations table" do
      it { expect(subject.has_column?(:country)).to be true }

      it { expect(subject.column(:country).data_type).to be :"platformer.iso_country" }

      it { expect(subject.column(:country).null).to be false }

      it { expect(subject.column(:country).description).to be_nil }

      it { expect(subject.column(:country).default).to be_nil }
    end
  end

  describe "for a User Model which has a country field that has a default value, allows null and has a description" do
    before(:each) do
      scaffold do
        model_for "Users::User" do
          database :postgres, :primary
          country_field allow_null: true do
            description "This is a description"
            database_default "UK"
          end
        end
      end
    end

    subject {
      Platformer::Databases.server(:postgres, :primary).default_database.structure.configured_schema(:public).table(:users)
    }

    context "creates the expected columns within the DynamicMigrations table" do
      it { expect(subject.has_column?(:country)).to be true }

      it { expect(subject.column(:country).data_type).to be :"platformer.iso_country" }

      it { expect(subject.column(:country).null).to be true }

      it { expect(subject.column(:country).description).to eq "This is a description" }

      it { expect(subject.column(:country).default).to eq "UK" }
    end
  end

  describe "for a User Model with an array of countrys" do
    before(:each) do
      scaffold do
        model_for "Users::User" do
          database :postgres, :primary
          country_field array: true
        end
      end
    end

    subject {
      Platformer::Databases.server(:postgres, :primary).default_database.structure.configured_schema(:public).table(:users)
    }

    context "creates the expected columns within the DynamicMigrations table" do
      it { expect(subject.has_column?(:country)).to be true }

      it { expect(subject.column(:country).data_type).to be :"platformer.iso_country[]" }
    end
  end
end
