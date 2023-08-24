# frozen_string_literal: true

require "spec_helper"

RSpec.describe Platformer::Composers::Migrations::Columns::UuidColumns do
  describe "for a new UserModel which defines a simple new model in a postgres database" do
    before(:each) do
      create_class "Users::UserModel", PlatformModel do
        database :postgres, :primary
      end
    end

    describe "with a uuid column named my_uuid" do
      before(:each) do
        Users::UserModel.uuid_field :my_uuid
      end

      it "creates the expected columns within the DynamicMigrations table" do
        # now that the UserModel has been created, we rerun the composer
        # and it's dependent composers
        Platformer::Composers::Migrations::CreateStructure.rerun
        Platformer::Composers::Migrations::Columns::UuidColumns.rerun

        table = Platformer::Databases.server(:postgres, :primary).default_database.structure.configured_schema(:public).table(:users)
        expect(table.has_column?(:my_uuid)).to be true
        expect(table.column(:my_uuid).data_type).to be :uuid
        # check for the expected defaults
        expect(table.column(:my_uuid).null).to be false
        expect(table.column(:my_uuid).description).to be_nil
        expect(table.column(:my_uuid).default).to be_nil
      end
    end

    describe "with a uuid column named my_uuid that has a default, allows null and has a comment" do
      before(:each) do
        Users::UserModel.uuid_field :my_uuid do
          allow_null
          comment "This is a comment"
          default "63510e31-bbf8-49e0-9878-ce2a974ead54"
        end
      end

      it "creates the expected columns within the DynamicMigrations table" do
        # now that the UserModel has been created, we rerun the composer
        # and it's dependent composers
        Platformer::Composers::Migrations::CreateStructure.rerun
        Platformer::Composers::Migrations::Columns::UuidColumns.rerun

        table = Platformer::Databases.server(:postgres, :primary).default_database.structure.configured_schema(:public).table(:users)
        expect(table.has_column?(:my_uuid)).to be true
        expect(table.column(:my_uuid).data_type).to be :uuid
        # check for the expected values
        expect(table.column(:my_uuid).null).to be true
        expect(table.column(:my_uuid).description).to eq "This is a comment"
        expect(table.column(:my_uuid).default).to eq "63510e31-bbf8-49e0-9878-ce2a974ead54"
      end
    end

    describe "with an array of uuids column named my_uuid" do
      before(:each) do
        Users::UserModel.uuid_field :my_uuid, array: true
      end

      it "creates the expected columns within the DynamicMigrations table" do
        # now that the UserModel has been created, we rerun the composer
        # and it's dependent composers
        Platformer::Composers::Migrations::CreateStructure.rerun
        Platformer::Composers::Migrations::Columns::UuidColumns.rerun

        table = Platformer::Databases.server(:postgres, :primary).default_database.structure.configured_schema(:public).table(:users)
        expect(table.has_column?(:my_uuid)).to be true
        expect(table.column(:my_uuid).data_type).to be :"uuid[]"
      end
    end
  end
end