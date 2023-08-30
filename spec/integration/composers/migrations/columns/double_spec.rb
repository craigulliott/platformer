# frozen_string_literal: true

require "spec_helper"

RSpec.describe Platformer::Composers::Migrations::Columns::Double do
  describe "for a new UserModel which defines a simple new model in a postgres database" do
    before(:each) do
      create_class "Users::UserModel", Platformer::BaseModel do
        database :postgres, :primary
      end
    end

    describe "with a double column named my_double" do
      before(:each) do
        Users::UserModel.double_field :my_double
      end

      it "creates the expected columns within the DynamicMigrations table" do
        # now that the UserModel has been created, we rerun the composer
        # and it's dependent composers
        Platformer::Composers::Migrations::CreateStructure.rerun
        Platformer::Composers::Migrations::Columns::Double.rerun

        table = Platformer::Databases.server(:postgres, :primary).default_database.structure.configured_schema(:public).table(:users)
        expect(table.has_column?(:my_double)).to be true
        expect(table.column(:my_double).data_type).to be :"double precision"
        # check for the expected defaults
        expect(table.column(:my_double).null).to be false
        expect(table.column(:my_double).description).to be_nil
        expect(table.column(:my_double).default).to be_nil
      end
    end

    describe "with a double column named my_double that has a default, allows null and has a comment" do
      before(:each) do
        Users::UserModel.double_field :my_double do
          allow_null
          comment "This is a comment"
          default 5
        end
      end

      it "creates the expected columns within the DynamicMigrations table" do
        # now that the UserModel has been created, we rerun the composer
        # and it's dependent composers
        Platformer::Composers::Migrations::CreateStructure.rerun
        Platformer::Composers::Migrations::Columns::Double.rerun

        table = Platformer::Databases.server(:postgres, :primary).default_database.structure.configured_schema(:public).table(:users)
        expect(table.has_column?(:my_double)).to be true
        expect(table.column(:my_double).data_type).to be :"double precision"
        # check for the expected values
        expect(table.column(:my_double).null).to be true
        expect(table.column(:my_double).description).to eq "This is a comment"
        expect(table.column(:my_double).default).to eq 5
      end
    end

    describe "with an array of doubles column named my_double" do
      before(:each) do
        Users::UserModel.double_field :my_double, array: true
      end

      it "creates the expected columns within the DynamicMigrations table" do
        # now that the UserModel has been created, we rerun the composer
        # and it's dependent composers
        Platformer::Composers::Migrations::CreateStructure.rerun
        Platformer::Composers::Migrations::Columns::Double.rerun

        table = Platformer::Databases.server(:postgres, :primary).default_database.structure.configured_schema(:public).table(:users)
        expect(table.has_column?(:my_double)).to be true
        expect(table.column(:my_double).data_type).to be :"double precision[]"
      end
    end
  end
end
