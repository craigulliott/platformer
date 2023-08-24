# frozen_string_literal: true

require "spec_helper"

RSpec.describe Platformer::Composers::Migrations::Columns::TextColumns do
  describe "for a new UserModel which defines a simple new model in a postgres database" do
    before(:each) do
      create_class "Users::UserModel", PlatformModel do
        database :postgres, :primary
      end
    end

    describe "with a text column named my_text" do
      before(:each) do
        Users::UserModel.text_field :my_text
      end

      it "creates the expected columns within the DynamicMigrations table" do
        # now that the UserModel has been created, we rerun the composer
        # and it's dependent composers
        Platformer::Composers::Migrations::CreateStructure.rerun
        Platformer::Composers::Migrations::Columns::TextColumns.rerun

        table = Platformer::Databases.server(:postgres, :primary).default_database.structure.configured_schema(:public).table(:users)
        expect(table.has_column?(:my_text)).to be true
        expect(table.column(:my_text).data_type).to be :text
        # check for the expected defaults
        expect(table.column(:my_text).null).to be false
        expect(table.column(:my_text).description).to be_nil
        expect(table.column(:my_text).default).to be_nil
      end
    end

    describe "with a text column named my_text that has a default, allows null and has a comment" do
      before(:each) do
        Users::UserModel.text_field :my_text do
          allow_null
          comment "This is a comment"
          default "Hi Katy!"
        end
      end

      it "creates the expected columns within the DynamicMigrations table" do
        # now that the UserModel has been created, we rerun the composer
        # and it's dependent composers
        Platformer::Composers::Migrations::CreateStructure.rerun
        Platformer::Composers::Migrations::Columns::TextColumns.rerun

        table = Platformer::Databases.server(:postgres, :primary).default_database.structure.configured_schema(:public).table(:users)
        expect(table.has_column?(:my_text)).to be true
        expect(table.column(:my_text).data_type).to be :text
        # check for the expected values
        expect(table.column(:my_text).null).to be true
        expect(table.column(:my_text).description).to eq "This is a comment"
        expect(table.column(:my_text).default).to eq "Hi Katy!"
      end
    end

    describe "with an array of texts column named my_text" do
      before(:each) do
        Users::UserModel.text_field :my_text, array: true
      end

      it "creates the expected columns within the DynamicMigrations table" do
        # now that the UserModel has been created, we rerun the composer
        # and it's dependent composers
        Platformer::Composers::Migrations::CreateStructure.rerun
        Platformer::Composers::Migrations::Columns::TextColumns.rerun

        table = Platformer::Databases.server(:postgres, :primary).default_database.structure.configured_schema(:public).table(:users)
        expect(table.has_column?(:my_text)).to be true
        expect(table.column(:my_text).data_type).to be :"text[]"
      end
    end
  end
end
