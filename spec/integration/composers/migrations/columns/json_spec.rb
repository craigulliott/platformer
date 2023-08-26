# frozen_string_literal: true

require "spec_helper"

RSpec.describe Platformer::Composers::Migrations::Columns::Json do
  describe "for a new UserModel which defines a simple new model in a postgres database" do
    before(:each) do
      create_class "Users::UserModel", PlatformModel do
        database :postgres, :primary
      end
    end

    describe "with a json column named my_json" do
      before(:each) do
        Users::UserModel.json_field :my_json
      end

      it "creates the expected columns within the DynamicMigrations table" do
        # now that the UserModel has been created, we rerun the composer
        # and it's dependent composers
        Platformer::Composers::Migrations::CreateStructure.rerun
        Platformer::Composers::Migrations::Columns::Json.rerun

        table = Platformer::Databases.server(:postgres, :primary).default_database.structure.configured_schema(:public).table(:users)
        expect(table.has_column?(:my_json)).to be true
        expect(table.column(:my_json).data_type).to be :jsonb
        # check for the expected defaults
        expect(table.column(:my_json).null).to be false
        expect(table.column(:my_json).description).to be_nil
        expect(table.column(:my_json).default).to be_nil
      end
    end

    describe "with a json column named my_json that has a default, allows null and has a comment" do
      before(:each) do
        Users::UserModel.json_field :my_json do
          allow_null
          comment "This is a comment"
          default '{"my_json": "bar"}'
        end
      end

      it "creates the expected columns within the DynamicMigrations table" do
        # now that the UserModel has been created, we rerun the composer
        # and it's dependent composers
        Platformer::Composers::Migrations::CreateStructure.rerun
        Platformer::Composers::Migrations::Columns::Json.rerun

        table = Platformer::Databases.server(:postgres, :primary).default_database.structure.configured_schema(:public).table(:users)
        expect(table.has_column?(:my_json)).to be true
        expect(table.column(:my_json).data_type).to be :jsonb
        # check for the expected values
        expect(table.column(:my_json).null).to be true
        expect(table.column(:my_json).description).to eq "This is a comment"
        expect(table.column(:my_json).default).to eq '{"my_json": "bar"}'
      end
    end
  end
end
