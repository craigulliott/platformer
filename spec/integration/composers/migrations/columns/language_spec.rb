# frozen_string_literal: true

require "spec_helper"

RSpec.describe Platformer::Composers::Migrations::Columns::Language do
  describe "for a User Model which has a language field" do
    before(:each) do
      scaffold do
        model_for "Users::User" do
          database :postgres, :primary
          language_field
        end
      end
    end

    subject {
      Platformer::Databases.server(:postgres, :primary).default_database.structure.configured_schema(:public).table(:users)
    }

    context "creates the expected columns within the DynamicMigrations table" do
      it { expect(subject.has_column?(:language)).to be true }

      it { expect(subject.column(:language).data_type).to be :"platformer.iso_language" }

      it { expect(subject.column(:language).null).to be false }

      it { expect(subject.column(:language).description).to be_nil }

      it { expect(subject.column(:language).default).to be_nil }
    end
  end

  describe "for a User Model which has a language field that has a default value, allows null and has a description" do
    before(:each) do
      scaffold do
        model_for "Users::User" do
          database :postgres, :primary
          language_field allow_null: true do
            description "This is a description"
            database_default "en"
          end
        end
      end
    end

    subject {
      Platformer::Databases.server(:postgres, :primary).default_database.structure.configured_schema(:public).table(:users)
    }

    context "creates the expected columns within the DynamicMigrations table" do
      it { expect(subject.has_column?(:language)).to be true }

      it { expect(subject.column(:language).data_type).to be :"platformer.iso_language" }

      it { expect(subject.column(:language).null).to be true }

      it { expect(subject.column(:language).description).to eq "This is a description" }

      it { expect(subject.column(:language).default).to eq "en" }
    end
  end

  describe "for a User Model with an array of languages" do
    before(:each) do
      scaffold do
        model_for "Users::User" do
          database :postgres, :primary
          language_field array: true
        end
      end
    end

    subject {
      Platformer::Databases.server(:postgres, :primary).default_database.structure.configured_schema(:public).table(:users)
    }

    context "creates the expected columns within the DynamicMigrations table" do
      it { expect(subject.has_column?(:language)).to be true }

      it { expect(subject.column(:language).data_type).to be :"platformer.iso_language[]" }
    end
  end
end
