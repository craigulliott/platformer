# frozen_string_literal: true

require "spec_helper"

RSpec.describe Platformer::Composers::Migrations::Columns::Country do
  describe "for a User Model which has a country column named my_country" do
    before(:each) do
      scaffold do
        model_for "Users::User" do
          database :postgres, :primary
          country_field :my_country
        end
      end
    end

    subject {
      Platformer::Databases.server(:postgres, :primary).default_database.structure.configured_schema(:public).table(:users)
    }

    context "creates the expected columns within the DynamicMigrations table" do
      it { expect(subject.has_column?(:my_country)).to be true }

      it { expect(subject.column(:my_country).data_type).to be :"platformer.iso_country_code" }

      it { expect(subject.column(:my_country).null).to be false }

      it { expect(subject.column(:my_country).description).to be_nil }

      it { expect(subject.column(:my_country).default).to be_nil }
    end
  end

  describe "for a User Model which has a country column named my_country that has a default value, allows null and has a comment" do
    before(:each) do
      scaffold do
        model_for "Users::User" do
          database :postgres, :primary
          country_field :my_country do
            allow_null
            comment "This is a comment"
            default "UK"
          end
        end
      end
    end

    subject {
      Platformer::Databases.server(:postgres, :primary).default_database.structure.configured_schema(:public).table(:users)
    }

    context "creates the expected columns within the DynamicMigrations table" do
      it { expect(subject.has_column?(:my_country)).to be true }

      it { expect(subject.column(:my_country).data_type).to be :"platformer.iso_country_code" }

      it { expect(subject.column(:my_country).null).to be true }

      it { expect(subject.column(:my_country).description).to eq "This is a comment" }

      it { expect(subject.column(:my_country).default).to eq "UK" }
    end
  end

  describe "for a User Model with an array of countrys column named my_country" do
    before(:each) do
      scaffold do
        model_for "Users::User" do
          database :postgres, :primary
          country_field :my_country, array: true
        end
      end
    end

    subject {
      Platformer::Databases.server(:postgres, :primary).default_database.structure.configured_schema(:public).table(:users)
    }

    context "creates the expected columns within the DynamicMigrations table" do
      it { expect(subject.has_column?(:my_country)).to be true }

      it { expect(subject.column(:my_country).data_type).to be :"platformer.iso_country_code[]" }
    end
  end
end
