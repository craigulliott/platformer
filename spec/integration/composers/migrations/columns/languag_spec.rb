# frozen_string_literal: true

require "spec_helper"

RSpec.describe Platformer::Composers::Migrations::Columns::Language do
  describe "for a new UserModel which defines a simple new model in a postgres database" do
    before(:each) do
      create_class "Users::UserModel", PlatformModel do
        database :postgres, :primary
      end
    end

    describe "with a language column named my_language" do
      before(:each) do
        Users::UserModel.language_field :my_language
      end

      it "creates the expected columns within the DynamicMigrations table" do
        # now that the UserModel has been created, we rerun the composer
        # and it's dependent composers
        Platformer::Composers::Migrations::CreateStructure.rerun
        Platformer::Composers::Migrations::Columns::Language.rerun

        table = Platformer::Databases.server(:postgres, :primary).default_database.structure.configured_schema(:public).table(:users)
        expect(table.has_column?(:my_language)).to be true
        expect(table.column(:my_language).data_type).to be :"platformer.iso_language_code"
        # check for the expected defaults
        expect(table.column(:my_language).null).to be false
        expect(table.column(:my_language).description).to be_nil
        expect(table.column(:my_language).default).to be_nil
      end
    end

    describe "with a language column named my_language that has a default, allows null and has a comment" do
      before(:each) do
        Users::UserModel.language_field :my_language do
          allow_null
          comment "This is a comment"
          default "en"
        end
      end

      it "creates the expected columns within the DynamicMigrations table" do
        # now that the UserModel has been created, we rerun the composer
        # and it's dependent composers
        Platformer::Composers::Migrations::CreateStructure.rerun
        Platformer::Composers::Migrations::Columns::Language.rerun

        table = Platformer::Databases.server(:postgres, :primary).default_database.structure.configured_schema(:public).table(:users)
        expect(table.has_column?(:my_language)).to be true
        expect(table.column(:my_language).data_type).to be :"platformer.iso_language_code"
        # check for the expected values
        expect(table.column(:my_language).null).to be true
        expect(table.column(:my_language).description).to eq "This is a comment"
        expect(table.column(:my_language).default).to eq "en"
      end
    end

    describe "with an array of languages column named my_language" do
      before(:each) do
        Users::UserModel.language_field :my_language, array: true
      end

      it "creates the expected columns within the DynamicMigrations table" do
        # now that the UserModel has been created, we rerun the composer
        # and it's dependent composers
        Platformer::Composers::Migrations::CreateStructure.rerun
        Platformer::Composers::Migrations::Columns::Language.rerun

        table = Platformer::Databases.server(:postgres, :primary).default_database.structure.configured_schema(:public).table(:users)
        expect(table.has_column?(:my_language)).to be true
        expect(table.column(:my_language).data_type).to be :"platformer.iso_language_code[]"
      end
    end
  end
end
