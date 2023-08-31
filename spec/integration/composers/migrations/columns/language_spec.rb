# frozen_string_literal: true

require "spec_helper"

RSpec.describe Platformer::Composers::Migrations::Columns::Language do
  describe "for a User Model which has a language column named my_language" do
    before(:each) do
      scaffold do
        model_for "Users::User" do
          database :postgres, :primary
          language_field :my_language
        end
      end
    end

    subject {
      Platformer::Databases.server(:postgres, :primary).default_database.structure.configured_schema(:public).table(:users)
    }

    context "creates the expected columns within the DynamicMigrations table" do
      it { expect(subject.has_column?(:my_language)).to be true }

      it { expect(subject.column(:my_language).data_type).to be :"platformer.iso_language_code" }

      it { expect(subject.column(:my_language).null).to be false }

      it { expect(subject.column(:my_language).description).to be_nil }

      it { expect(subject.column(:my_language).default).to be_nil }
    end
  end

  describe "for a User Model which has a language column named my_language that has a default value, allows null and has a comment" do
    before(:each) do
      scaffold do
        model_for "Users::User" do
          database :postgres, :primary
          language_field :my_language do
            allow_null
            comment "This is a comment"
            default "en"
          end
        end
      end
    end

    subject {
      Platformer::Databases.server(:postgres, :primary).default_database.structure.configured_schema(:public).table(:users)
    }

    context "creates the expected columns within the DynamicMigrations table" do
      it { expect(subject.has_column?(:my_language)).to be true }

      it { expect(subject.column(:my_language).data_type).to be :"platformer.iso_language_code" }

      it { expect(subject.column(:my_language).null).to be true }

      it { expect(subject.column(:my_language).description).to eq "This is a comment" }

      it { expect(subject.column(:my_language).default).to eq "en" }
    end
  end

  describe "for a User Model with an array of languages column named my_language" do
    before(:each) do
      scaffold do
        model_for "Users::User" do
          database :postgres, :primary
          language_field :my_language, array: true
        end
      end
    end

    subject {
      Platformer::Databases.server(:postgres, :primary).default_database.structure.configured_schema(:public).table(:users)
    }

    context "creates the expected columns within the DynamicMigrations table" do
      it { expect(subject.has_column?(:my_language)).to be true }

      it { expect(subject.column(:my_language).data_type).to be :"platformer.iso_language_code[]" }
    end
  end
end
