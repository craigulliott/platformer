# frozen_string_literal: true

require "spec_helper"

RSpec.describe Platformer::Composers::Migrations::Columns::PhoneNumber do
  describe "for a User Model which has a phone_number field" do
    before(:each) do
      scaffold do
        model_for "Users::User" do
          database :postgres, :primary
          phone_number_field
        end
      end
    end

    subject {
      Platformer::Databases.server(:postgres, :primary).default_database.structure.configured_schema(:public).table(:users)
    }

    context "creates the expected columns within the DynamicMigrations table" do
      context "a column dedicated to the international dialing code" do
        it { expect(subject.has_column?(:dialing_code)).to be true }

        it { expect(subject.column(:dialing_code).data_type).to be :"platformer.iso_dialing_code" }

        it { expect(subject.column(:dialing_code).null).to be false }

        it {
          expect(subject.column(:dialing_code).description).to eq <<~DESCRIPTION.strip
            This is the international dialing code (without the + symbol)
            e.g. "1" for the USA and "44" for the UK.
          DESCRIPTION
        }

        it { expect(subject.column(:dialing_code).default).to be_nil }
      end

      context "a column dedicated to the phone number" do
        it { expect(subject.has_column?(:phone_number)).to be true }

        it { expect(subject.column(:phone_number).data_type).to be :"character varying(15)" }

        it { expect(subject.column(:phone_number).null).to be false }

        it {
          expect(subject.column(:phone_number).description).to eq <<~DESCRIPTION.strip
            This is the unformatted phone number without the international dialing
            code. For example, in the US this is a 10 digit number.
          DESCRIPTION
        }

        it { expect(subject.column(:phone_number).default).to be_nil }
      end
    end
  end
end
