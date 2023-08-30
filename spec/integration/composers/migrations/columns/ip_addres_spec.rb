# frozen_string_literal: true

require "spec_helper"

RSpec.describe Platformer::Composers::Migrations::Columns::IpAddress do
  describe "for a new UserModel which defines a simple new model in a postgres database" do
    before(:each) do
      create_class "Users::UserModel", Platformer::BaseModel do
        database :postgres, :primary
      end
    end

    describe "with a inet column named my_ip_address" do
      before(:each) do
        Users::UserModel.ip_address_field :my_ip_address
      end

      it "creates the expected columns within the DynamicMigrations table" do
        # now that the UserModel has been created, we rerun the composer
        # and it's dependent composers
        Platformer::Composers::Migrations::CreateStructure.rerun
        Platformer::Composers::Migrations::Columns::IpAddress.rerun

        table = Platformer::Databases.server(:postgres, :primary).default_database.structure.configured_schema(:public).table(:users)
        expect(table.has_column?(:my_ip_address)).to be true
        expect(table.column(:my_ip_address).data_type).to be :inet
        # check for the expected defaults
        expect(table.column(:my_ip_address).null).to be false
        expect(table.column(:my_ip_address).description).to be_nil
        expect(table.column(:my_ip_address).default).to be_nil
      end
    end

    describe "with a inet column named my_ip_address that has a default, allows null and has a comment" do
      before(:each) do
        Users::UserModel.ip_address_field :my_ip_address do
          allow_null
          comment "This is a comment"
          default "192.168.0.1"
        end
      end

      it "creates the expected columns within the DynamicMigrations table" do
        # now that the UserModel has been created, we rerun the composer
        # and it's dependent composers
        Platformer::Composers::Migrations::CreateStructure.rerun
        Platformer::Composers::Migrations::Columns::IpAddress.rerun

        table = Platformer::Databases.server(:postgres, :primary).default_database.structure.configured_schema(:public).table(:users)
        expect(table.has_column?(:my_ip_address)).to be true
        expect(table.column(:my_ip_address).data_type).to be :inet
        # check for the expected values
        expect(table.column(:my_ip_address).null).to be true
        expect(table.column(:my_ip_address).description).to eq "This is a comment"
        expect(table.column(:my_ip_address).default).to eq "192.168.0.1"
      end
    end

    describe "with an array of inets column named my_ip_address" do
      before(:each) do
        Users::UserModel.ip_address_field :my_ip_address, array: true
      end

      it "creates the expected columns within the DynamicMigrations table" do
        # now that the UserModel has been created, we rerun the composer
        # and it's dependent composers
        Platformer::Composers::Migrations::CreateStructure.rerun
        Platformer::Composers::Migrations::Columns::IpAddress.rerun

        table = Platformer::Databases.server(:postgres, :primary).default_database.structure.configured_schema(:public).table(:users)
        expect(table.has_column?(:my_ip_address)).to be true
        expect(table.column(:my_ip_address).data_type).to be :"inet[]"
      end
    end
  end
end
