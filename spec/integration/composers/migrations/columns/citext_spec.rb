# frozen_string_literal: true

require "spec_helper"

RSpec.describe Platformer::Composers::Migrations::Columns::Citext do
  describe "for a new UserModel which defines a simple new model in a postgres database" do
    before(:each) do
      create_class "Users::UserModel", PlatformModel do
        database :postgres, :primary
      end
    end

    describe "with a citext column named my_citext" do
      before(:each) do
        Users::UserModel.citext_field :my_citext
      end

      it "creates the expected columns within the DynamicMigrations table" do
        # now that the UserModel has been created, we rerun the composer
        # and it's dependent composers
        Platformer::Composers::Migrations::CreateStructure.rerun
        Platformer::Composers::Migrations::Columns::Citext.rerun

        table = Platformer::Databases.server(:postgres, :primary).default_database.structure.configured_schema(:public).table(:users)
        expect(table.has_column?(:my_citext)).to be true
        expect(table.column(:my_citext).data_type).to be :citext
        # check for the expected defaults
        expect(table.column(:my_citext).null).to be false
        expect(table.column(:my_citext).description).to be_nil
        expect(table.column(:my_citext).default).to be_nil
      end
    end

    describe "with a citext column named my_citext that has a default, allows null and has a comment" do
      before(:each) do
        Users::UserModel.citext_field :my_citext do
          allow_null
          comment "This is a comment"
          default "Hi Katy!"
        end
      end

      it "creates the expected columns within the DynamicMigrations table" do
        # now that the UserModel has been created, we rerun the composer
        # and it's dependent composers
        Platformer::Composers::Migrations::CreateStructure.rerun
        Platformer::Composers::Migrations::Columns::Citext.rerun

        table = Platformer::Databases.server(:postgres, :primary).default_database.structure.configured_schema(:public).table(:users)
        expect(table.has_column?(:my_citext)).to be true
        expect(table.column(:my_citext).data_type).to be :citext
        # check for the expected values
        expect(table.column(:my_citext).null).to be true
        expect(table.column(:my_citext).description).to eq "This is a comment"
        expect(table.column(:my_citext).default).to eq "Hi Katy!"
      end
    end

    describe "with an array of citexts column named my_citext" do
      before(:each) do
        Users::UserModel.citext_field :my_citext, array: true
      end

      it "creates the expected columns within the DynamicMigrations table" do
        # now that the UserModel has been created, we rerun the composer
        # and it's dependent composers
        Platformer::Composers::Migrations::CreateStructure.rerun
        Platformer::Composers::Migrations::Columns::Citext.rerun

        table = Platformer::Databases.server(:postgres, :primary).default_database.structure.configured_schema(:public).table(:users)
        expect(table.has_column?(:my_citext)).to be true
        expect(table.column(:my_citext).data_type).to be :"citext[]"
      end
    end
  end
end
