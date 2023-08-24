# frozen_string_literal: true

require "spec_helper"

RSpec.describe Platformer::Composers::Migrations::Columns::NumericColumns do
  describe "for a new UserModel which defines a simple new model in a postgres database" do
    before(:each) do
      create_class "Users::UserModel", PlatformModel do
        database :postgres, :primary
      end
    end

    describe "with a numeric column named my_numeric" do
      before(:each) do
        Users::UserModel.numeric_field :my_numeric
      end

      it "creates the expected columns within the DynamicMigrations table" do
        # now that the UserModel has been created, we rerun the composer
        # and it's dependent composers
        Platformer::Composers::Migrations::CreateStructure.rerun
        Platformer::Composers::Migrations::Columns::NumericColumns.rerun

        table = Platformer::Databases.server(:postgres, :primary).default_database.structure.configured_schema(:public).table(:users)
        expect(table.has_column?(:my_numeric)).to be true
        expect(table.column(:my_numeric).data_type).to be :numeric
        # check for the expected defaults
        expect(table.column(:my_numeric).null).to be false
        expect(table.column(:my_numeric).description).to be_nil
        expect(table.column(:my_numeric).default).to be_nil
      end
    end

    describe "with a numeric column named my_numeric that has a default, allows null and has a comment" do
      before(:each) do
        Users::UserModel.numeric_field :my_numeric do
          allow_null
          comment "This is a comment"
          default 5
        end
      end

      it "creates the expected columns within the DynamicMigrations table" do
        # now that the UserModel has been created, we rerun the composer
        # and it's dependent composers
        Platformer::Composers::Migrations::CreateStructure.rerun
        Platformer::Composers::Migrations::Columns::NumericColumns.rerun

        table = Platformer::Databases.server(:postgres, :primary).default_database.structure.configured_schema(:public).table(:users)
        expect(table.has_column?(:my_numeric)).to be true
        expect(table.column(:my_numeric).data_type).to be :numeric
        # check for the expected values
        expect(table.column(:my_numeric).null).to be true
        expect(table.column(:my_numeric).description).to eq "This is a comment"
        expect(table.column(:my_numeric).default).to eq 5
      end
    end

    describe "with an array of numerics column named my_numeric" do
      before(:each) do
        Users::UserModel.numeric_field :my_numeric, array: true
      end

      it "creates the expected columns within the DynamicMigrations table" do
        # now that the UserModel has been created, we rerun the composer
        # and it's dependent composers
        Platformer::Composers::Migrations::CreateStructure.rerun
        Platformer::Composers::Migrations::Columns::NumericColumns.rerun

        table = Platformer::Databases.server(:postgres, :primary).default_database.structure.configured_schema(:public).table(:users)
        expect(table.has_column?(:my_numeric)).to be true
        expect(table.column(:my_numeric).data_type).to be :"numeric[]"
      end
    end

    describe "with a numeric column named my_numeric which has a specific precision and scale" do
      before(:each) do
        Users::UserModel.numeric_field :my_numeric, precision: 12, scale: 2
      end

      it "creates the expected columns within the DynamicMigrations table" do
        # now that the UserModel has been created, we rerun the composer
        # and it's dependent composers
        Platformer::Composers::Migrations::CreateStructure.rerun
        Platformer::Composers::Migrations::Columns::NumericColumns.rerun

        table = Platformer::Databases.server(:postgres, :primary).default_database.structure.configured_schema(:public).table(:users)
        expect(table.has_column?(:my_numeric)).to be true
        expect(table.column(:my_numeric).data_type).to be :"numeric(12,2)"
      end
    end
  end
end
