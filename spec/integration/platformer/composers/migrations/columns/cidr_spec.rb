# frozen_string_literal: true

require "spec_helper"

RSpec.describe Platformer::Composers::Migrations::Columns::Cidr do
  describe "for a User Model which has a cidr column named my_cidr" do
    before(:each) do
      scaffold do
        model_for "Users::User" do
          database :postgres, :primary
          cidr_field :my_cidr
        end
      end
    end

    subject {
      Platformer::Databases.server(:postgres, :primary).default_database.structure.configured_schema(:public).table(:users)
    }

    context "creates the expected columns within the DynamicMigrations table" do
      it { expect(subject.has_column?(:my_cidr)).to be true }

      it { expect(subject.column(:my_cidr).data_type).to be :cidr }

      it { expect(subject.column(:my_cidr).null).to be false }

      it { expect(subject.column(:my_cidr).description).to be_nil }

      it { expect(subject.column(:my_cidr).default).to be_nil }
    end
  end

  describe "for a User Model which has a cidr column named my_cidr that has a default value, allows null and has a description" do
    before(:each) do
      scaffold do
        model_for "Users::User" do
          database :postgres, :primary
          cidr_field :my_cidr, allow_null: true do
            description "This is a description"
            database_default "10.0.0.0/8"
          end
        end
      end
    end

    subject {
      Platformer::Databases.server(:postgres, :primary).default_database.structure.configured_schema(:public).table(:users)
    }

    context "creates the expected columns within the DynamicMigrations table" do
      it { expect(subject.has_column?(:my_cidr)).to be true }

      it { expect(subject.column(:my_cidr).data_type).to be :cidr }

      it { expect(subject.column(:my_cidr).null).to be true }

      it { expect(subject.column(:my_cidr).description).to eq "This is a description" }

      it { expect(subject.column(:my_cidr).default).to eq "10.0.0.0/8" }
    end
  end

  describe "for a User Model with an array of cidrs column named my_cidr" do
    before(:each) do
      scaffold do
        model_for "Users::User" do
          database :postgres, :primary
          cidr_field :my_cidr, array: true
        end
      end
    end

    subject {
      Platformer::Databases.server(:postgres, :primary).default_database.structure.configured_schema(:public).table(:users)
    }

    context "creates the expected columns within the DynamicMigrations table" do
      it { expect(subject.has_column?(:my_cidr)).to be true }

      it { expect(subject.column(:my_cidr).data_type).to be :"cidr[]" }
    end
  end
end
