# frozen_string_literal: true

require "spec_helper"

RSpec.describe Platformer::Composers::Migrations::Columns::Enum do
  describe "for a new UserModel which defines a simple new model in a postgres database" do
    before(:each) do
      create_class "Users::UserModel", Platformer::BaseModel do
        database :postgres, :primary
      end
    end

    describe "with a enum column named my_enum" do
      before(:each) do
        Users::UserModel.enum_field :my_enum, [
          "foo",
          "bar"
        ]
      end

      it "creates the expected columns within the DynamicMigrations table" do
        # now that the UserModel has been created, we rerun the composer
        # and it's dependent composers
        Platformer::Composers::Migrations::CreateStructure.rerun
        Platformer::Composers::Migrations::Columns::Enum.rerun

        table = Platformer::Databases.server(:postgres, :primary).default_database.structure.configured_schema(:public).table(:users)
        expect(table.has_column?(:my_enum)).to be true
        expect(table.column(:my_enum).data_type).to be :users__my_enum_values
        # check for the expected defaults
        expect(table.column(:my_enum).null).to be false
        expect(table.column(:my_enum).description).to be_nil
        expect(table.column(:my_enum).default).to be_nil
      end
    end

    describe "with a enum column named my_enum that has a default, allows null and has a comment" do
      before(:each) do
        Users::UserModel.enum_field :my_enum, ["foo", "bar"] do
          allow_null
          comment "This is a comment"
          default "foo"
        end
      end

      it "creates the expected columns within the DynamicMigrations table" do
        # now that the UserModel has been created, we rerun the composer
        # and it's dependent composers
        Platformer::Composers::Migrations::CreateStructure.rerun
        Platformer::Composers::Migrations::Columns::Enum.rerun

        table = Platformer::Databases.server(:postgres, :primary).default_database.structure.configured_schema(:public).table(:users)
        expect(table.has_column?(:my_enum)).to be true
        expect(table.column(:my_enum).data_type).to be :users__my_enum_values
        # check for the expected values
        expect(table.column(:my_enum).null).to be true
        expect(table.column(:my_enum).description).to eq "This is a comment"
        expect(table.column(:my_enum).default).to eq "foo"
      end
    end

    describe "with an array of enums column named my_enum" do
      before(:each) do
        Users::UserModel.enum_field :my_enum, ["foo", "bar"], array: true
      end

      it "creates the expected columns within the DynamicMigrations table" do
        # now that the UserModel has been created, we rerun the composer
        # and it's dependent composers
        Platformer::Composers::Migrations::CreateStructure.rerun
        Platformer::Composers::Migrations::Columns::Enum.rerun

        table = Platformer::Databases.server(:postgres, :primary).default_database.structure.configured_schema(:public).table(:users)
        expect(table.has_column?(:my_enum)).to be true
        expect(table.column(:my_enum).data_type).to be :"users__my_enum_values[]"
      end
    end
  end
end
