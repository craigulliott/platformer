# frozen_string_literal: true

require "spec_helper"

RSpec.describe Platformer::Composers::Migrations::Columns::Currency do
  describe "for a new UserModel which defines a simple new model in a postgres database" do
    before(:each) do
      create_class "Users::UserModel", PlatformModel do
        database :postgres, :primary
      end
    end

    describe "with a currency column named my_currency" do
      before(:each) do
        Users::UserModel.currency_field :my_currency
      end

      it "creates the expected columns within the DynamicMigrations table" do
        # now that the UserModel has been created, we rerun the composer
        # and it's dependent composers
        Platformer::Composers::Migrations::CreateStructure.rerun
        Platformer::Composers::Migrations::Columns::Currency.rerun

        table = Platformer::Databases.server(:postgres, :primary).default_database.structure.configured_schema(:public).table(:users)
        expect(table.has_column?(:my_currency)).to be true
        expect(table.column(:my_currency).data_type).to be :"platformer.iso_currency_code"
        # check for the expected defaults
        expect(table.column(:my_currency).null).to be false
        expect(table.column(:my_currency).description).to be_nil
        expect(table.column(:my_currency).default).to be_nil
      end
    end

    describe "with a currency column named my_currency that has a default, allows null and has a comment" do
      before(:each) do
        Users::UserModel.currency_field :my_currency do
          allow_null
          comment "This is a comment"
          default "USD"
        end
      end

      it "creates the expected columns within the DynamicMigrations table" do
        # now that the UserModel has been created, we rerun the composer
        # and it's dependent composers
        Platformer::Composers::Migrations::CreateStructure.rerun
        Platformer::Composers::Migrations::Columns::Currency.rerun

        table = Platformer::Databases.server(:postgres, :primary).default_database.structure.configured_schema(:public).table(:users)
        expect(table.has_column?(:my_currency)).to be true
        expect(table.column(:my_currency).data_type).to be :"platformer.iso_currency_code"
        # check for the expected values
        expect(table.column(:my_currency).null).to be true
        expect(table.column(:my_currency).description).to eq "This is a comment"
        expect(table.column(:my_currency).default).to eq "USD"
      end
    end

    describe "with an array of currencys column named my_currency" do
      before(:each) do
        Users::UserModel.currency_field :my_currency, array: true
      end

      it "creates the expected columns within the DynamicMigrations table" do
        # now that the UserModel has been created, we rerun the composer
        # and it's dependent composers
        Platformer::Composers::Migrations::CreateStructure.rerun
        Platformer::Composers::Migrations::Columns::Currency.rerun

        table = Platformer::Databases.server(:postgres, :primary).default_database.structure.configured_schema(:public).table(:users)
        expect(table.has_column?(:my_currency)).to be true
        expect(table.column(:my_currency).data_type).to be :"platformer.iso_currency_code[]"
      end
    end
  end
end
