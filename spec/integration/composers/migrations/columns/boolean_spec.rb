# frozen_string_literal: true

require "spec_helper"

RSpec.describe Platformer::Composers::Migrations::Columns::Boolean do
  describe "for a new UserModel which defines a simple new model in a postgres database" do
    before(:each) do
      create_class "Users::UserModel", PlatformModel do
        database :postgres, :primary
      end
    end

    describe "with a boolean column named my_boolean" do
      before(:each) do
        Users::UserModel.boolean_field :my_boolean
      end

      it "creates the expected columns within the DynamicMigrations table" do
        # now that the UserModel has been created, we rerun the composer
        # and it's dependent composers
        Platformer::Composers::Migrations::CreateStructure.rerun
        Platformer::Composers::Migrations::Columns::Boolean.rerun

        table = Platformer::Databases.server(:postgres, :primary).default_database.structure.configured_schema(:public).table(:users)
        expect(table.has_column?(:my_boolean)).to be true
        expect(table.column(:my_boolean).data_type).to be :boolean
        # check for the expected defaults
        expect(table.column(:my_boolean).null).to be false
        expect(table.column(:my_boolean).description).to be_nil
        expect(table.column(:my_boolean).default).to be_nil
      end
    end

    describe "with a boolean column named my_boolean that has a default, allows null and has a comment" do
      before(:each) do
        Users::UserModel.boolean_field :my_boolean do
          allow_null
          comment "This is a comment"
          default true
        end
      end

      it "creates the expected columns within the DynamicMigrations table" do
        # now that the UserModel has been created, we rerun the composer
        # and it's dependent composers
        Platformer::Composers::Migrations::CreateStructure.rerun
        Platformer::Composers::Migrations::Columns::Boolean.rerun

        table = Platformer::Databases.server(:postgres, :primary).default_database.structure.configured_schema(:public).table(:users)
        expect(table.has_column?(:my_boolean)).to be true
        expect(table.column(:my_boolean).data_type).to be :boolean
        # check for the expected values
        expect(table.column(:my_boolean).null).to be true
        expect(table.column(:my_boolean).description).to eq "This is a comment"
        expect(table.column(:my_boolean).default).to be true
      end
    end

    describe "with an array of booleans column named my_boolean" do
      before(:each) do
        Users::UserModel.boolean_field :my_boolean, array: true
      end

      it "creates the expected columns within the DynamicMigrations table" do
        # now that the UserModel has been created, we rerun the composer
        # and it's dependent composers
        Platformer::Composers::Migrations::CreateStructure.rerun
        Platformer::Composers::Migrations::Columns::Boolean.rerun

        table = Platformer::Databases.server(:postgres, :primary).default_database.structure.configured_schema(:public).table(:users)
        expect(table.has_column?(:my_boolean)).to be true
        expect(table.column(:my_boolean).data_type).to be :"boolean[]"
      end
    end
  end
end
