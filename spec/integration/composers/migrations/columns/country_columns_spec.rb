# frozen_string_literal: true

require "spec_helper"

RSpec.describe Platformer::Composers::Migrations::Columns::CountryColumns do
  describe "for a new UserModel which defines a simple new model in a postgres database" do
    before(:each) do
      create_class "Users::UserModel", PlatformModel do
        database :postgres, :primary
      end
    end

    describe "with a country column named my_country" do
      before(:each) do
        Users::UserModel.country_field :my_country
      end

      it "creates the expected columns within the DynamicMigrations table" do
        # now that the UserModel has been created, we rerun the composer
        # and it's dependent composers
        Platformer::Composers::Migrations::CreateStructure.rerun
        Platformer::Composers::Migrations::Columns::CountryColumns.rerun

        table = Platformer::Databases.server(:postgres, :primary).default_database.structure.configured_schema(:public).table(:users)
        expect(table.has_column?(:my_country)).to be true
        expect(table.column(:my_country).data_type).to be :"platformer.iso_country_code"
        # check for the expected defaults
        expect(table.column(:my_country).null).to be false
        expect(table.column(:my_country).description).to be_nil
        expect(table.column(:my_country).default).to be_nil
      end
    end

    describe "with a country column named my_country that has a default, allows null and has a comment" do
      before(:each) do
        Users::UserModel.country_field :my_country do
          allow_null
          comment "This is a comment"
          default "UK"
        end
      end

      it "creates the expected columns within the DynamicMigrations table" do
        # now that the UserModel has been created, we rerun the composer
        # and it's dependent composers
        Platformer::Composers::Migrations::CreateStructure.rerun
        Platformer::Composers::Migrations::Columns::CountryColumns.rerun

        table = Platformer::Databases.server(:postgres, :primary).default_database.structure.configured_schema(:public).table(:users)
        expect(table.has_column?(:my_country)).to be true
        expect(table.column(:my_country).data_type).to be :"platformer.iso_country_code"
        # check for the expected values
        expect(table.column(:my_country).null).to be true
        expect(table.column(:my_country).description).to eq "This is a comment"
        expect(table.column(:my_country).default).to eq "UK"
      end
    end

    describe "with an array of countrys column named my_country" do
      before(:each) do
        Users::UserModel.country_field :my_country, array: true
      end

      it "creates the expected columns within the DynamicMigrations table" do
        # now that the UserModel has been created, we rerun the composer
        # and it's dependent composers
        Platformer::Composers::Migrations::CreateStructure.rerun
        Platformer::Composers::Migrations::Columns::CountryColumns.rerun

        table = Platformer::Databases.server(:postgres, :primary).default_database.structure.configured_schema(:public).table(:users)
        expect(table.has_column?(:my_country)).to be true
        expect(table.column(:my_country).data_type).to be :"platformer.iso_country_code[]"
      end
    end
  end
end
