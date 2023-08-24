# frozen_string_literal: true

require "spec_helper"

RSpec.describe Platformer::Composers::Migrations::Columns::DateColumns do
  describe "for a new UserModel which defines a simple new model in a postgres database" do
    before(:each) do
      create_class "Users::UserModel", PlatformModel do
        database :postgres, :primary
      end
    end

    describe "with a date column named my_date" do
      before(:each) do
        Users::UserModel.date_field :my_date
      end

      it "creates the expected columns within the DynamicMigrations table" do
        # now that the UserModel has been created, we rerun the composer
        # and it's dependent composers
        Platformer::Composers::Migrations::CreateStructure.rerun
        Platformer::Composers::Migrations::Columns::DateColumns.rerun

        table = Platformer::Databases.server(:postgres, :primary).default_database.structure.configured_schema(:public).table(:users)
        expect(table.has_column?(:my_date)).to be true
        expect(table.column(:my_date).data_type).to be :date
        # check for the expected defaults
        expect(table.column(:my_date).null).to be false
        expect(table.column(:my_date).description).to be_nil
        expect(table.column(:my_date).default).to be_nil
      end
    end

    describe "with a date column named my_date that has a default, allows null and has a comment" do
      before(:each) do
        Users::UserModel.date_field :my_date do
          allow_null
          comment "This is a comment"
          default "2023-05-08"
        end
      end

      it "creates the expected columns within the DynamicMigrations table" do
        # now that the UserModel has been created, we rerun the composer
        # and it's dependent composers
        Platformer::Composers::Migrations::CreateStructure.rerun
        Platformer::Composers::Migrations::Columns::DateColumns.rerun

        table = Platformer::Databases.server(:postgres, :primary).default_database.structure.configured_schema(:public).table(:users)
        expect(table.has_column?(:my_date)).to be true
        expect(table.column(:my_date).data_type).to be :date
        # check for the expected values
        expect(table.column(:my_date).null).to be true
        expect(table.column(:my_date).description).to eq "This is a comment"
        expect(table.column(:my_date).default).to eql "2023-05-08"
      end
    end

    describe "with an array of dates column named my_date" do
      before(:each) do
        Users::UserModel.date_field :my_date, array: true
      end

      it "creates the expected columns within the DynamicMigrations table" do
        # now that the UserModel has been created, we rerun the composer
        # and it's dependent composers
        Platformer::Composers::Migrations::CreateStructure.rerun
        Platformer::Composers::Migrations::Columns::DateColumns.rerun

        table = Platformer::Databases.server(:postgres, :primary).default_database.structure.configured_schema(:public).table(:users)
        expect(table.has_column?(:my_date)).to be true
        expect(table.column(:my_date).data_type).to be :"date[]"
      end
    end
  end
end
