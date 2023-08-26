# frozen_string_literal: true

require "spec_helper"

RSpec.describe Platformer::Composers::Migrations::Columns::Integer do
  describe "for a new UserModel which defines a simple new model in a postgres database" do
    before(:each) do
      create_class "Users::UserModel", PlatformModel do
        database :postgres, :primary
      end
    end

    describe "with an integer column named my_integer" do
      before(:each) do
        Users::UserModel.integer_field :my_integer
      end

      it "creates the expected columns within the DynamicMigrations table" do
        # now that the UserModel has been created, we rerun the composer
        # and it's dependent composers
        Platformer::Composers::Migrations::CreateStructure.rerun
        Platformer::Composers::Migrations::Columns::Integer.rerun

        table = Platformer::Databases.server(:postgres, :primary).default_database.structure.configured_schema(:public).table(:users)
        expect(table.has_column?(:my_integer)).to be true
        expect(table.column(:my_integer).data_type).to be :integer
        # check for the expected defaults
        expect(table.column(:my_integer).null).to be false
        expect(table.column(:my_integer).description).to be_nil
        expect(table.column(:my_integer).default).to be_nil
      end
    end

    describe "with an integer column named my_integer that has a default, allows null and has a comment" do
      before(:each) do
        Users::UserModel.integer_field :my_integer do
          allow_null
          comment "This is a comment"
          default 5
        end
      end

      it "creates the expected columns within the DynamicMigrations table" do
        # now that the UserModel has been created, we rerun the composer
        # and it's dependent composers
        Platformer::Composers::Migrations::CreateStructure.rerun
        Platformer::Composers::Migrations::Columns::Integer.rerun

        table = Platformer::Databases.server(:postgres, :primary).default_database.structure.configured_schema(:public).table(:users)
        expect(table.has_column?(:my_integer)).to be true
        expect(table.column(:my_integer).data_type).to be :integer
        # check for the expected values
        expect(table.column(:my_integer).null).to be true
        expect(table.column(:my_integer).description).to eq "This is a comment"
        expect(table.column(:my_integer).default).to eq 5
      end
    end

    describe "with an array of integers column named my_integer" do
      before(:each) do
        Users::UserModel.integer_field :my_integer, array: true
      end

      it "creates the expected columns within the DynamicMigrations table" do
        # now that the UserModel has been created, we rerun the composer
        # and it's dependent composers
        Platformer::Composers::Migrations::CreateStructure.rerun
        Platformer::Composers::Migrations::Columns::Integer.rerun

        table = Platformer::Databases.server(:postgres, :primary).default_database.structure.configured_schema(:public).table(:users)
        expect(table.has_column?(:my_integer)).to be true
        expect(table.column(:my_integer).data_type).to be :"integer[]"
      end
    end
  end
end
