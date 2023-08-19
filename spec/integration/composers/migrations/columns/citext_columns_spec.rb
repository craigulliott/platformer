# frozen_string_literal: true

require "spec_helper"

RSpec.describe Platformer::Composers::Migrations::Columns::CitextColumns do
  describe "for a new UserModel which defines a simple new model in a postgres database" do
    before(:each) do
      create_class "Users::UserModel", PlatformModel do
        database :postgres, :primary
      end
    end

    describe "with a citext column named foo" do
      before(:each) do
        Users::UserModel.citext_field :foo
      end

      it "creates the expected columns within the DynamicMigrations table" do
        # now that the UserModel has been created, we rerun the composer
        # and it's dependent composers
        Platformer::Composers::Migrations::CreateStructure.rerun
        Platformer::Composers::Migrations::Columns::CitextColumns.rerun

        table = Platformer::Databases.server(:postgres, :primary).default_database.structure.configured_schema(:public).table(:users)
        expect(table.has_column?(:foo)).to be true
        expect(table.column(:foo).data_type).to be :citext
        # check for the expected defaults
        expect(table.column(:foo).null).to be false
        expect(table.column(:foo).description).to be_nil
        expect(table.column(:foo).default).to be_nil
      end
    end

    describe "with a citext column named foo that has a default, allows null and has a comment" do
      before(:each) do
        Users::UserModel.citext_field :foo do
          allow_null
          comment "This is a comment"
          default "Hi Katy!"
        end
      end

      it "creates the expected columns within the DynamicMigrations table" do
        # now that the UserModel has been created, we rerun the composer
        # and it's dependent composers
        Platformer::Composers::Migrations::CreateStructure.rerun
        Platformer::Composers::Migrations::Columns::CitextColumns.rerun

        table = Platformer::Databases.server(:postgres, :primary).default_database.structure.configured_schema(:public).table(:users)
        expect(table.has_column?(:foo)).to be true
        expect(table.column(:foo).data_type).to be :citext
        # check for the expected values
        expect(table.column(:foo).null).to be true
        expect(table.column(:foo).description).to eq "This is a comment"
        expect(table.column(:foo).default).to eq "Hi Katy!"
      end
    end

    describe "with an array of citexts column named foo" do
      before(:each) do
        Users::UserModel.citext_field :foo, array: true
      end

      it "creates the expected columns within the DynamicMigrations table" do
        # now that the UserModel has been created, we rerun the composer
        # and it's dependent composers
        Platformer::Composers::Migrations::CreateStructure.rerun
        Platformer::Composers::Migrations::Columns::CitextColumns.rerun

        table = Platformer::Databases.server(:postgres, :primary).default_database.structure.configured_schema(:public).table(:users)
        expect(table.has_column?(:foo)).to be true
        expect(table.column(:foo).data_type).to be :"citext[]"
      end
    end
  end
end
