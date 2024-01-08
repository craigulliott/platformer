# frozen_string_literal: true

require "spec_helper"

RSpec.describe Platformer::Composers::Migrations::Columns::Citext do
  describe "for a User Model which has a citext column named my_citext" do
    before(:each) do
      scaffold do
        model_for "Users::User" do
          database :postgres, :primary
          citext_field :my_citext
        end
      end
    end

    subject {
      Platformer::Databases.server(:postgres, :primary).default_database.structure.configured_schema(:public).table(:users)
    }

    context "creates the expected columns within the DynamicMigrations table" do
      it { expect(subject.has_column?(:my_citext)).to be true }

      it { expect(subject.column(:my_citext).data_type).to be :citext }

      it { expect(subject.column(:my_citext).null).to be false }

      it { expect(subject.column(:my_citext).description).to be_nil }

      it { expect(subject.column(:my_citext).default).to be_nil }
    end
  end

  describe "for a User Model which has a citext column named my_citext that has a default value, allows null and has a description" do
    before(:each) do
      scaffold do
        model_for "Users::User" do
          database :postgres, :primary
          citext_field :my_citext, allow_null: true do
            description "This is a description"
            database_default "Hi Katy"
          end
        end
      end
    end

    subject {
      Platformer::Databases.server(:postgres, :primary).default_database.structure.configured_schema(:public).table(:users)
    }

    context "creates the expected columns within the DynamicMigrations table" do
      it { expect(subject.has_column?(:my_citext)).to be true }

      it { expect(subject.column(:my_citext).data_type).to be :citext }

      it { expect(subject.column(:my_citext).null).to be true }

      it { expect(subject.column(:my_citext).description).to eq "This is a description" }

      it { expect(subject.column(:my_citext).default).to eq "Hi Katy" }
    end
  end

  describe "for a User Model with an array of citexts column named my_citext" do
    before(:each) do
      scaffold do
        model_for "Users::User" do
          database :postgres, :primary
          citext_field :my_citext, array: true
        end
      end
    end

    subject {
      Platformer::Databases.server(:postgres, :primary).default_database.structure.configured_schema(:public).table(:users)
    }

    context "creates the expected columns within the DynamicMigrations table" do
      it { expect(subject.has_column?(:my_citext)).to be true }

      it { expect(subject.column(:my_citext).data_type).to be :"citext[]" }
    end
  end
end
