# frozen_string_literal: true

require "spec_helper"

RSpec.describe Platformer::Composers::Migrations::Columns::CidrColumns do
  describe "for a new UserModel which defines a simple new model in a postgres database" do
    before(:each) do
      create_class "Users::UserModel", PlatformModel do
        database :postgres, :primary
      end
    end

    describe "with a cidr column named my_cidr" do
      before(:each) do
        Users::UserModel.cidr_field :my_cidr
      end

      it "creates the expected columns within the DynamicMigrations table" do
        # now that the UserModel has been created, we rerun the composer
        # and it's dependent composers
        Platformer::Composers::Migrations::CreateStructure.rerun
        Platformer::Composers::Migrations::Columns::CidrColumns.rerun

        table = Platformer::Databases.server(:postgres, :primary).default_database.structure.configured_schema(:public).table(:users)
        expect(table.has_column?(:my_cidr)).to be true
        expect(table.column(:my_cidr).data_type).to be :cidr
        # check for the expected defaults
        expect(table.column(:my_cidr).null).to be false
        expect(table.column(:my_cidr).description).to be_nil
        expect(table.column(:my_cidr).default).to be_nil
      end
    end

    describe "with a cidr column named my_cidr that has a default, allows null and has a comment" do
      before(:each) do
        Users::UserModel.cidr_field :my_cidr do
          allow_null
          comment "This is a comment"
          default "10.0.0.0/8"
        end
      end

      it "creates the expected columns within the DynamicMigrations table" do
        # now that the UserModel has been created, we rerun the composer
        # and it's dependent composers
        Platformer::Composers::Migrations::CreateStructure.rerun
        Platformer::Composers::Migrations::Columns::CidrColumns.rerun

        table = Platformer::Databases.server(:postgres, :primary).default_database.structure.configured_schema(:public).table(:users)
        expect(table.has_column?(:my_cidr)).to be true
        expect(table.column(:my_cidr).data_type).to be :cidr
        # check for the expected values
        expect(table.column(:my_cidr).null).to be true
        expect(table.column(:my_cidr).description).to eq "This is a comment"
        expect(table.column(:my_cidr).default).to eq "10.0.0.0/8"
      end
    end

    describe "with an array of cidrs column named my_cidr" do
      before(:each) do
        Users::UserModel.cidr_field :my_cidr, array: true
      end

      it "creates the expected columns within the DynamicMigrations table" do
        # now that the UserModel has been created, we rerun the composer
        # and it's dependent composers
        Platformer::Composers::Migrations::CreateStructure.rerun
        Platformer::Composers::Migrations::Columns::CidrColumns.rerun

        table = Platformer::Databases.server(:postgres, :primary).default_database.structure.configured_schema(:public).table(:users)
        expect(table.has_column?(:my_cidr)).to be true
        expect(table.column(:my_cidr).data_type).to be :"cidr[]"
      end
    end
  end
end
