# frozen_string_literal: true

require "spec_helper"

RSpec.describe Platformer::Composers::Migrations::Columns::JSONColumns do
  describe "for a new UserModel which defines a simple new model in a postgres database" do
    before(:each) do
      create_class "Users::UserModel", PlatformModel do
        database :postgres, :primary
      end
    end

    describe "with a json column named foo" do
      before(:each) do
        Users::UserModel.json_field :foo
      end

      it "creates the expected columns within the DynamicMigrations table" do
        # now that the UserModel has been created, we rerun the composer
        # and it's dependent composers
        Platformer::Composers::Migrations::CreateStructure.rerun
        Platformer::Composers::Migrations::Columns::JSONColumns.rerun

        table = Platformer::Databases.server(:postgres, :primary).default_database.structure.configured_schema(:public).table(:users)
        expect(table.has_column?(:foo)).to be true
        expect(table.column(:foo).data_type).to be :json
        # check for the expected defaults
        expect(table.column(:foo).null).to be false
        expect(table.column(:foo).description).to be_nil
        expect(table.column(:foo).default).to be_nil
      end
    end

    describe "with a json column named foo that has a default, allows null and has a comment" do
      before(:each) do
        Users::UserModel.json_field :foo do
          allow_null
          comment "This is a comment"
          default '{"foo": "bar"}'
        end
      end

      it "creates the expected columns within the DynamicMigrations table" do
        # now that the UserModel has been created, we rerun the composer
        # and it's dependent composers
        Platformer::Composers::Migrations::CreateStructure.rerun
        Platformer::Composers::Migrations::Columns::JSONColumns.rerun

        table = Platformer::Databases.server(:postgres, :primary).default_database.structure.configured_schema(:public).table(:users)
        expect(table.has_column?(:foo)).to be true
        expect(table.column(:foo).data_type).to be :json
        # check for the expected values
        expect(table.column(:foo).null).to be true
        expect(table.column(:foo).description).to eq "This is a comment"
        expect(table.column(:foo).default).to eq '{"foo": "bar"}'
      end
    end

    describe "with a json column named foo that coerces empty json objects to null" do
      before(:each) do
        Users::UserModel.json_field :foo do
          empty_json_to_null
        end
      end

      it "creates the expected columns within the DynamicMigrations table" do
        # now that the UserModel has been created, we rerun the composer
        # and it's dependent composers
        Platformer::Composers::Migrations::CreateStructure.rerun
        Platformer::Composers::Migrations::Columns::JSONColumns.rerun

        table = Platformer::Databases.server(:postgres, :primary).default_database.structure.configured_schema(:public).table(:users)
        raise "todo"
      end
    end
  end
end
