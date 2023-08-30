# frozen_string_literal: true

require "spec_helper"

RSpec.describe Platformer::Composers::Migrations::Columns::Email do
  describe "for a new UserModel which defines a simple new model in a postgres database" do
    before(:each) do
      create_class "Users::UserModel", Platformer::BaseModel do
        database :postgres, :primary
      end
    end

    describe "with a email column named my_email" do
      before(:each) do
        Users::UserModel.email_field :my_email
      end

      it "creates the expected columns within the DynamicMigrations table" do
        # now that the UserModel has been created, we rerun the composer
        # and it's dependent composers
        Platformer::Composers::Migrations::CreateStructure.rerun
        Platformer::Composers::Migrations::Columns::Email.rerun

        table = Platformer::Databases.server(:postgres, :primary).default_database.structure.configured_schema(:public).table(:users)
        expect(table.has_column?(:my_email)).to be true
        expect(table.column(:my_email).data_type).to be :email
        # check for the expected defaults
        expect(table.column(:my_email).null).to be false
        expect(table.column(:my_email).description).to be_nil
        expect(table.column(:my_email).default).to be_nil
      end
    end

    describe "with a email column named my_email that has a default, allows null and has a comment" do
      before(:each) do
        Users::UserModel.email_field :my_email do
          allow_null
          comment "This is a comment"
          default "Hi Katy!"
        end
      end

      it "creates the expected columns within the DynamicMigrations table" do
        # now that the UserModel has been created, we rerun the composer
        # and it's dependent composers
        Platformer::Composers::Migrations::CreateStructure.rerun
        Platformer::Composers::Migrations::Columns::Email.rerun

        table = Platformer::Databases.server(:postgres, :primary).default_database.structure.configured_schema(:public).table(:users)
        expect(table.has_column?(:my_email)).to be true
        expect(table.column(:my_email).data_type).to be :email
        # check for the expected values
        expect(table.column(:my_email).null).to be true
        expect(table.column(:my_email).description).to eq "This is a comment"
        expect(table.column(:my_email).default).to eq "Hi Katy!"
      end
    end

    describe "with an array of emails column named my_email" do
      before(:each) do
        Users::UserModel.email_field :my_email, array: true
      end

      it "creates the expected columns within the DynamicMigrations table" do
        # now that the UserModel has been created, we rerun the composer
        # and it's dependent composers
        Platformer::Composers::Migrations::CreateStructure.rerun
        Platformer::Composers::Migrations::Columns::Email.rerun

        table = Platformer::Databases.server(:postgres, :primary).default_database.structure.configured_schema(:public).table(:users)
        expect(table.has_column?(:my_email)).to be true
        expect(table.column(:my_email).data_type).to be :"email[]"
      end
    end
  end
end
