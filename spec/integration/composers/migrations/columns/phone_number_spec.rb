# frozen_string_literal: true

require "spec_helper"

RSpec.describe Platformer::Composers::Migrations::Columns::PhoneNumber do
  describe "for a new UserModel which defines a simple new model in a postgres database" do
    before(:each) do
      create_class "Users::UserModel", Platformer::BaseModel do
        database :postgres, :primary
      end
    end

    describe "with a phone_number column named my_phone_number" do
      before(:each) do
        Users::UserModel.phone_number_field :my_phone_number
      end

      it "creates the expected columns within the DynamicMigrations table" do
        # now that the UserModel has been created, we rerun the composer
        # and it's dependent composers
        Platformer::Composers::Migrations::CreateStructure.rerun
        Platformer::Composers::Migrations::Columns::PhoneNumber.rerun

        table = Platformer::Databases.server(:postgres, :primary).default_database.structure.configured_schema(:public).table(:users)

        expect(table.has_column?(:my_phone_number_dialing_code)).to be true
        expect(table.column(:my_phone_number_dialing_code).data_type).to be :"platformer.iso_dialing_code"
        # check for the expected defaults
        expect(table.column(:my_phone_number_dialing_code).null).to be false
        expect(table.column(:my_phone_number_dialing_code).description).to eq <<~DESCRIPTION.strip
          This is the international dialing code, which is a + followed by a
          number (e.g. "+1" for the USA and "+44" for the UK).
        DESCRIPTION
        expect(table.column(:my_phone_number_dialing_code).default).to be_nil

        expect(table.has_column?(:my_phone_number_phone_number)).to be true
        expect(table.column(:my_phone_number_phone_number).data_type).to be :"varchar(15)"
        # check for the expected defaults
        expect(table.column(:my_phone_number_phone_number).null).to be false
        expect(table.column(:my_phone_number_phone_number).description).to eq <<~DESCRIPTION.strip
          This is the unformatted phone number without the international dialing
          code. For example, in the US this is a 10 digit number.
        DESCRIPTION
        expect(table.column(:my_phone_number_phone_number).default).to be_nil
      end
    end

    describe "with a phone_number column named my_phone_number that has a default, allows null and has a comment" do
      before(:each) do
        Users::UserModel.phone_number_field :my_phone_number do
          allow_null
          comment "Here is a comment."
          default "+1", "1234567890"
        end
      end

      it "creates the expected columns within the DynamicMigrations table" do
        # now that the UserModel has been created, we rerun the composer
        # and it's dependent composers
        Platformer::Composers::Migrations::CreateStructure.rerun
        Platformer::Composers::Migrations::Columns::PhoneNumber.rerun

        table = Platformer::Databases.server(:postgres, :primary).default_database.structure.configured_schema(:public).table(:users)

        expect(table.has_column?(:my_phone_number_dialing_code)).to be true
        expect(table.column(:my_phone_number_dialing_code).data_type).to be :"platformer.iso_dialing_code"
        # check for the expected defaults
        expect(table.column(:my_phone_number_dialing_code).null).to be true
        expect(table.column(:my_phone_number_dialing_code).default).to eq "+1"
        expect(table.column(:my_phone_number_dialing_code).description).to eq <<~DESCRIPTION.strip
          Here is a comment.
          This is the international dialing code, which is a + followed by a
          number (e.g. "+1" for the USA and "+44" for the UK).
        DESCRIPTION

        expect(table.has_column?(:my_phone_number_phone_number)).to be true
        expect(table.column(:my_phone_number_phone_number).data_type).to be :"varchar(15)"
        # check for the expected defaults
        expect(table.column(:my_phone_number_phone_number).null).to be true
        expect(table.column(:my_phone_number_phone_number).default).to eq "1234567890"
        expect(table.column(:my_phone_number_phone_number).description).to eq <<~DESCRIPTION.strip
          Here is a comment.
          This is the unformatted phone number without the international dialing
          code. For example, in the US this is a 10 digit number.
        DESCRIPTION
      end
    end
  end
end
