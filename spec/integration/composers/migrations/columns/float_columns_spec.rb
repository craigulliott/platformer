# frozen_string_literal: true

require "spec_helper"

RSpec.describe Platformer::Composers::Migrations::Columns::FloatColumns do
  describe "for a new UserModel which defines a simple new model in a postgres database" do
    before(:each) do
      create_class "Users::UserModel", PlatformModel do
        database :postgres, :primary
      end
    end

    describe "with a float column named my_float" do
      before(:each) do
        Users::UserModel.float_field :my_float
      end

      it "creates the expected columns within the DynamicMigrations table" do
        # now that the UserModel has been created, we rerun the composer
        # and it's dependent composers
        Platformer::Composers::Migrations::CreateStructure.rerun
        Platformer::Composers::Migrations::Columns::FloatColumns.rerun

        table = Platformer::Databases.server(:postgres, :primary).default_database.structure.configured_schema(:public).table(:users)
        expect(table.has_column?(:my_float)).to be true
        expect(table.column(:my_float).data_type).to be :real
        # check for the expected defaults
        expect(table.column(:my_float).null).to be false
        expect(table.column(:my_float).description).to be_nil
        expect(table.column(:my_float).default).to be_nil
      end
    end

    describe "with a float column named my_float that has a default, allows null and has a comment" do
      before(:each) do
        Users::UserModel.float_field :my_float do
          allow_null
          comment "This is a comment"
          default 5
        end
      end

      it "creates the expected columns within the DynamicMigrations table" do
        # now that the UserModel has been created, we rerun the composer
        # and it's dependent composers
        Platformer::Composers::Migrations::CreateStructure.rerun
        Platformer::Composers::Migrations::Columns::FloatColumns.rerun

        table = Platformer::Databases.server(:postgres, :primary).default_database.structure.configured_schema(:public).table(:users)
        expect(table.has_column?(:my_float)).to be true
        expect(table.column(:my_float).data_type).to be :real
        # check for the expected values
        expect(table.column(:my_float).null).to be true
        expect(table.column(:my_float).description).to eq "This is a comment"
        expect(table.column(:my_float).default).to eq 5
      end
    end

    describe "with an array of floats column named my_float" do
      before(:each) do
        Users::UserModel.float_field :my_float, array: true
      end

      it "creates the expected columns within the DynamicMigrations table" do
        # now that the UserModel has been created, we rerun the composer
        # and it's dependent composers
        Platformer::Composers::Migrations::CreateStructure.rerun
        Platformer::Composers::Migrations::Columns::FloatColumns.rerun

        table = Platformer::Databases.server(:postgres, :primary).default_database.structure.configured_schema(:public).table(:users)
        expect(table.has_column?(:my_float)).to be true
        expect(table.column(:my_float).data_type).to be :"real[]"
      end
    end
  end
end
