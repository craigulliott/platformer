# frozen_string_literal: true

require "spec_helper"

RSpec.describe Platformer::Composers::Migrations::Columns::Double do
  describe "for a User Model which has a double column named my_double" do
    before(:each) do
      scaffold do
        model_for "Users::User" do
          database :postgres, :primary
          double_field :my_double
        end
      end
    end

    subject {
      Platformer::Databases.server(:postgres, :primary).default_database.structure.configured_schema(:public).table(:users)
    }

    context "creates the expected columns within the DynamicMigrations table" do
      it { expect(subject.has_column?(:my_double)).to be true }

      it { expect(subject.column(:my_double).data_type).to be :"double precision" }

      it { expect(subject.column(:my_double).null).to be false }

      it { expect(subject.column(:my_double).description).to be_nil }

      it { expect(subject.column(:my_double).default).to be_nil }
    end
  end

  describe "for a User Model which has a double column named my_double that has a default value, allows null and has a description" do
    before(:each) do
      scaffold do
        model_for "Users::User" do
          database :postgres, :primary
          double_field :my_double do
            allow_null
            description "This is a description"
            database_default "8.88"
          end
        end
      end
    end

    subject {
      Platformer::Databases.server(:postgres, :primary).default_database.structure.configured_schema(:public).table(:users)
    }

    context "creates the expected columns within the DynamicMigrations table" do
      it { expect(subject.has_column?(:my_double)).to be true }

      it { expect(subject.column(:my_double).data_type).to be :"double precision" }

      it { expect(subject.column(:my_double).null).to be true }

      it { expect(subject.column(:my_double).description).to eq "This is a description" }

      it { expect(subject.column(:my_double).default).to eq "8.88" }
    end
  end

  describe "for a User Model with an array of doubles column named my_double" do
    before(:each) do
      scaffold do
        model_for "Users::User" do
          database :postgres, :primary
          double_field :my_double, array: true
        end
      end
    end

    subject {
      Platformer::Databases.server(:postgres, :primary).default_database.structure.configured_schema(:public).table(:users)
    }

    context "creates the expected columns within the DynamicMigrations table" do
      it { expect(subject.has_column?(:my_double)).to be true }

      it { expect(subject.column(:my_double).data_type).to be :"double precision[]" }
    end
  end
end
