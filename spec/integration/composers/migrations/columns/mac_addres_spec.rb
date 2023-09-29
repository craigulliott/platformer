# frozen_string_literal: true

require "spec_helper"

RSpec.describe Platformer::Composers::Migrations::Columns::MacAddress do
  describe "for a User Model which has a mac_address column named my_mac_address" do
    before(:each) do
      scaffold do
        model_for "Users::User" do
          database :postgres, :primary
          mac_address_field :my_mac_address
        end
      end
    end

    subject {
      Platformer::Databases.server(:postgres, :primary).default_database.structure.configured_schema(:public).table(:users)
    }

    context "creates the expected columns within the DynamicMigrations table" do
      it { expect(subject.has_column?(:my_mac_address)).to be true }

      it { expect(subject.column(:my_mac_address).data_type).to be :macaddr }

      it { expect(subject.column(:my_mac_address).null).to be false }

      it { expect(subject.column(:my_mac_address).description).to be_nil }

      it { expect(subject.column(:my_mac_address).default).to be_nil }
    end
  end

  describe "for a User Model which has a mac_address column named my_mac_address that has a default value, allows null and has a description" do
    before(:each) do
      scaffold do
        model_for "Users::User" do
          database :postgres, :primary
          mac_address_field :my_mac_address do
            allow_null
            description "This is a description"
            database_default "58-50-4A-2E-29-AB"
          end
        end
      end
    end

    subject {
      Platformer::Databases.server(:postgres, :primary).default_database.structure.configured_schema(:public).table(:users)
    }

    context "creates the expected columns within the DynamicMigrations table" do
      it { expect(subject.has_column?(:my_mac_address)).to be true }

      it { expect(subject.column(:my_mac_address).data_type).to be :macaddr }

      it { expect(subject.column(:my_mac_address).null).to be true }

      it { expect(subject.column(:my_mac_address).description).to eq "This is a description" }

      it { expect(subject.column(:my_mac_address).default).to eq "58-50-4A-2E-29-AB" }
    end
  end

  describe "for a User Model with an array of mac_addresss column named my_mac_address" do
    before(:each) do
      scaffold do
        model_for "Users::User" do
          database :postgres, :primary
          mac_address_field :my_mac_address, array: true
        end
      end
    end

    subject {
      Platformer::Databases.server(:postgres, :primary).default_database.structure.configured_schema(:public).table(:users)
    }

    context "creates the expected columns within the DynamicMigrations table" do
      it { expect(subject.has_column?(:my_mac_address)).to be true }

      it { expect(subject.column(:my_mac_address).data_type).to be :"macaddr[]" }
    end
  end
end
