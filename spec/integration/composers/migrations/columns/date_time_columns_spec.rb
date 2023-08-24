# frozen_string_literal: true

require "spec_helper"

RSpec.describe Platformer::Composers::Migrations::Columns::DateTimeColumns do
  describe "for a new UserModel which defines a simple new model in a postgres database" do
    before(:each) do
      create_class "Users::UserModel", PlatformModel do
        database :postgres, :primary
      end
    end

    describe "with a date_time column named my_date_time" do
      before(:each) do
        Users::UserModel.date_time_field :my_date_time
      end

      it "creates the expected columns within the DynamicMigrations table" do
        # now that the UserModel has been created, we rerun the composer
        # and it's dependent composers
        Platformer::Composers::Migrations::CreateStructure.rerun
        Platformer::Composers::Migrations::Columns::DateTimeColumns.rerun

        table = Platformer::Databases.server(:postgres, :primary).default_database.structure.configured_schema(:public).table(:users)
        expect(table.has_column?(:my_date_time)).to be true
        expect(table.column(:my_date_time).data_type).to be :timestamp
        # check for the expected defaults
        expect(table.column(:my_date_time).null).to be false
        expect(table.column(:my_date_time).description).to be_nil
        expect(table.column(:my_date_time).default).to be_nil
      end
    end

    describe "with a date_time column named my_date_time that has a default, allows null and has a comment" do
      before(:each) do
        Users::UserModel.date_time_field :my_date_time do
          allow_null
          comment "This is a comment"
          default "2023-07-14 12:00:00"
        end
      end

      it "creates the expected columns within the DynamicMigrations table" do
        # now that the UserModel has been created, we rerun the composer
        # and it's dependent composers
        Platformer::Composers::Migrations::CreateStructure.rerun
        Platformer::Composers::Migrations::Columns::DateTimeColumns.rerun

        table = Platformer::Databases.server(:postgres, :primary).default_database.structure.configured_schema(:public).table(:users)
        expect(table.has_column?(:my_date_time)).to be true
        expect(table.column(:my_date_time).data_type).to be :timestamp
        # check for the expected values
        expect(table.column(:my_date_time).null).to be true
        expect(table.column(:my_date_time).description).to eq "This is a comment"
        expect(table.column(:my_date_time).default).to eql "2023-07-14 12:00:00"
      end
    end

    describe "with an array of date_times column named my_date_time" do
      before(:each) do
        Users::UserModel.date_time_field :my_date_time, array: true
      end

      it "creates the expected columns within the DynamicMigrations table" do
        # now that the UserModel has been created, we rerun the composer
        # and it's dependent composers
        Platformer::Composers::Migrations::CreateStructure.rerun
        Platformer::Composers::Migrations::Columns::DateTimeColumns.rerun

        table = Platformer::Databases.server(:postgres, :primary).default_database.structure.configured_schema(:public).table(:users)
        expect(table.has_column?(:my_date_time)).to be true
        expect(table.column(:my_date_time).data_type).to be :"timestamp[]"
      end
    end
  end
end
