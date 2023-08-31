# frozen_string_literal: true

require "spec_helper"

RSpec.describe Platformer::Composers::Migrations::Columns::IpAddress do
  describe "for a User Model which has a ip_address column named my_ip_address" do
    before(:each) do
      scaffold do
        model_for "Users::User" do
          database :postgres, :primary
          ip_address_field :my_ip_address
        end
      end
    end

    subject {
      Platformer::Databases.server(:postgres, :primary).default_database.structure.configured_schema(:public).table(:users)
    }

    context "creates the expected columns within the DynamicMigrations table" do
      it { expect(subject.has_column?(:my_ip_address)).to be true }

      it { expect(subject.column(:my_ip_address).data_type).to be :inet }

      it { expect(subject.column(:my_ip_address).null).to be false }

      it { expect(subject.column(:my_ip_address).description).to be_nil }

      it { expect(subject.column(:my_ip_address).default).to be_nil }
    end
  end

  describe "for a User Model which has a ip_address column named my_ip_address that has a default value, allows null and has a comment" do
    before(:each) do
      scaffold do
        model_for "Users::User" do
          database :postgres, :primary
          ip_address_field :my_ip_address do
            allow_null
            comment "This is a comment"
            default "192.168.0.1"
          end
        end
      end
    end

    subject {
      Platformer::Databases.server(:postgres, :primary).default_database.structure.configured_schema(:public).table(:users)
    }

    context "creates the expected columns within the DynamicMigrations table" do
      it { expect(subject.has_column?(:my_ip_address)).to be true }

      it { expect(subject.column(:my_ip_address).data_type).to be :inet }

      it { expect(subject.column(:my_ip_address).null).to be true }

      it { expect(subject.column(:my_ip_address).description).to eq "This is a comment" }

      it { expect(subject.column(:my_ip_address).default).to eq "192.168.0.1" }
    end
  end

  describe "for a User Model with an array of ip_addresss column named my_ip_address" do
    before(:each) do
      scaffold do
        model_for "Users::User" do
          database :postgres, :primary
          ip_address_field :my_ip_address, array: true
        end
      end
    end

    subject {
      Platformer::Databases.server(:postgres, :primary).default_database.structure.configured_schema(:public).table(:users)
    }

    context "creates the expected columns within the DynamicMigrations table" do
      it { expect(subject.has_column?(:my_ip_address)).to be true }

      it { expect(subject.column(:my_ip_address).data_type).to be :"inet[]" }
    end
  end
end
