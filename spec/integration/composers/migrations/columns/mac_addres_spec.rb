# frozen_string_literal: true

require "spec_helper"

RSpec.describe Platformer::Composers::Migrations::Columns::MacAddress do
  describe "for a new UserModel which defines a simple new model in a postgres database" do
    before(:each) do
      create_class "Users::UserModel", Platformer::BaseModel do
        database :postgres, :primary
      end
    end

    describe "with a mac_address column named my_mac_address" do
      before(:each) do
        Users::UserModel.mac_address_field :my_mac_address
      end

      it "creates the expected columns within the DynamicMigrations table" do
        # now that the UserModel has been created, we rerun the composer
        # and it's dependent composers
        Platformer::Composers::Migrations::CreateStructure.rerun
        Platformer::Composers::Migrations::Columns::MacAddress.rerun

        table = Platformer::Databases.server(:postgres, :primary).default_database.structure.configured_schema(:public).table(:users)
        expect(table.has_column?(:my_mac_address)).to be true
        expect(table.column(:my_mac_address).data_type).to be :macaddr
        # check for the expected defaults
        expect(table.column(:my_mac_address).null).to be false
        expect(table.column(:my_mac_address).description).to be_nil
        expect(table.column(:my_mac_address).default).to be_nil
      end
    end

    describe "with a mac_address column named my_mac_address that has a default, allows null and has a comment" do
      before(:each) do
        Users::UserModel.mac_address_field :my_mac_address do
          allow_null
          comment "This is a comment"
          default "58-50-4A-2E-29-AB"
        end
      end

      it "creates the expected columns within the DynamicMigrations table" do
        # now that the UserModel has been created, we rerun the composer
        # and it's dependent composers
        Platformer::Composers::Migrations::CreateStructure.rerun
        Platformer::Composers::Migrations::Columns::MacAddress.rerun

        table = Platformer::Databases.server(:postgres, :primary).default_database.structure.configured_schema(:public).table(:users)
        expect(table.has_column?(:my_mac_address)).to be true
        expect(table.column(:my_mac_address).data_type).to be :macaddr
        # check for the expected values
        expect(table.column(:my_mac_address).null).to be true
        expect(table.column(:my_mac_address).description).to eq "This is a comment"
        expect(table.column(:my_mac_address).default).to eq "58-50-4A-2E-29-AB"
      end
    end

    describe "with an array of mac_addresss column named my_mac_address" do
      before(:each) do
        Users::UserModel.mac_address_field :my_mac_address, array: true
      end

      it "creates the expected columns within the DynamicMigrations table" do
        # now that the UserModel has been created, we rerun the composer
        # and it's dependent composers
        Platformer::Composers::Migrations::CreateStructure.rerun
        Platformer::Composers::Migrations::Columns::MacAddress.rerun

        table = Platformer::Databases.server(:postgres, :primary).default_database.structure.configured_schema(:public).table(:users)
        expect(table.has_column?(:my_mac_address)).to be true
        expect(table.column(:my_mac_address).data_type).to be :"macaddr[]"
      end
    end
  end
end
