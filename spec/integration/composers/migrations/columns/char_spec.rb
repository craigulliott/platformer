# frozen_string_literal: true

require "spec_helper"

RSpec.describe Platformer::Composers::Migrations::Columns::Char do
  describe "for a new UserModel which defines a simple new model in a postgres database" do
    before(:each) do
      create_class "Users::UserModel", Platformer::BaseModel do
        database :postgres, :primary
      end
    end

    describe "with a char column named my_char" do
      before(:each) do
        Users::UserModel.char_field :my_char
      end

      it "creates the expected columns within the DynamicMigrations table" do
        # now that the UserModel has been created, we rerun the composer
        # and it's dependent composers
        Platformer::Composers::Migrations::CreateStructure.rerun
        Platformer::Composers::Migrations::Columns::Char.rerun

        table = Platformer::Databases.server(:postgres, :primary).default_database.structure.configured_schema(:public).table(:users)
        expect(table.has_column?(:my_char)).to be true
        expect(table.column(:my_char).data_type).to be :char
        # check for the expected defaults
        expect(table.column(:my_char).null).to be false
        expect(table.column(:my_char).description).to be_nil
        expect(table.column(:my_char).default).to be_nil
      end
    end

    describe "with a char column named my_char that has a default, allows null and has a comment" do
      before(:each) do
        Users::UserModel.char_field :my_char do
          allow_null
          comment "This is a comment"
          default "Hi Katy!"
        end
      end

      it "creates the expected columns within the DynamicMigrations table" do
        # now that the UserModel has been created, we rerun the composer
        # and it's dependent composers
        Platformer::Composers::Migrations::CreateStructure.rerun
        Platformer::Composers::Migrations::Columns::Char.rerun

        table = Platformer::Databases.server(:postgres, :primary).default_database.structure.configured_schema(:public).table(:users)
        expect(table.has_column?(:my_char)).to be true
        expect(table.column(:my_char).data_type).to be :char
        # check for the expected values
        expect(table.column(:my_char).null).to be true
        expect(table.column(:my_char).description).to eq "This is a comment"
        expect(table.column(:my_char).default).to eq "Hi Katy!"
      end
    end

    describe "with an array of chars column named my_char" do
      before(:each) do
        Users::UserModel.char_field :my_char, array: true
      end

      it "creates the expected columns within the DynamicMigrations table" do
        # now that the UserModel has been created, we rerun the composer
        # and it's dependent composers
        Platformer::Composers::Migrations::CreateStructure.rerun
        Platformer::Composers::Migrations::Columns::Char.rerun

        table = Platformer::Databases.server(:postgres, :primary).default_database.structure.configured_schema(:public).table(:users)
        expect(table.has_column?(:my_char)).to be true
        expect(table.column(:my_char).data_type).to be :"char[]"
      end
    end

    describe "with a char column named my_char which has a specific length" do
      before(:each) do
        Users::UserModel.char_field :my_char, length: 8
      end

      it "creates the expected columns within the DynamicMigrations table" do
        # now that the UserModel has been created, we rerun the composer
        # and it's dependent composers
        Platformer::Composers::Migrations::CreateStructure.rerun
        Platformer::Composers::Migrations::Columns::Char.rerun

        table = Platformer::Databases.server(:postgres, :primary).default_database.structure.configured_schema(:public).table(:users)
        expect(table.has_column?(:my_char)).to be true
        expect(table.column(:my_char).data_type).to be :"char(8)"
      end
    end
  end
end
