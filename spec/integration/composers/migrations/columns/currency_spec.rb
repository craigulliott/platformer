# frozen_string_literal: true

require "spec_helper"

RSpec.describe Platformer::Composers::Migrations::Columns::Currency do
  describe "for a User Model which has a currency column named my_currency" do
    before(:each) do
      scaffold do
        model_for "Users::User" do
          database :postgres, :primary
          currency_field :my_currency
        end
      end
    end

    subject {
      Platformer::Databases.server(:postgres, :primary).default_database.structure.configured_schema(:public).table(:users)
    }

    context "creates the expected columns within the DynamicMigrations table" do
      it { expect(subject.has_column?(:my_currency)).to be true }

      it { expect(subject.column(:my_currency).data_type).to be :"platformer.iso_currency_code" }

      it { expect(subject.column(:my_currency).null).to be false }

      it { expect(subject.column(:my_currency).description).to be_nil }

      it { expect(subject.column(:my_currency).default).to be_nil }
    end
  end

  describe "for a User Model which has a currency column named my_currency that has a default value, allows null and has a comment" do
    before(:each) do
      scaffold do
        model_for "Users::User" do
          database :postgres, :primary
          currency_field :my_currency do
            allow_null
            comment "This is a comment"
            default "USD"
          end
        end
      end
    end

    subject {
      Platformer::Databases.server(:postgres, :primary).default_database.structure.configured_schema(:public).table(:users)
    }

    context "creates the expected columns within the DynamicMigrations table" do
      it { expect(subject.has_column?(:my_currency)).to be true }

      it { expect(subject.column(:my_currency).data_type).to be :"platformer.iso_currency_code" }

      it { expect(subject.column(:my_currency).null).to be true }

      it { expect(subject.column(:my_currency).description).to eq "This is a comment" }

      it { expect(subject.column(:my_currency).default).to eq "USD" }
    end
  end

  describe "for a User Model with an array of currencys column named my_currency" do
    before(:each) do
      scaffold do
        model_for "Users::User" do
          database :postgres, :primary
          currency_field :my_currency, array: true
        end
      end
    end

    subject {
      Platformer::Databases.server(:postgres, :primary).default_database.structure.configured_schema(:public).table(:users)
    }

    context "creates the expected columns within the DynamicMigrations table" do
      it { expect(subject.has_column?(:my_currency)).to be true }

      it { expect(subject.column(:my_currency).data_type).to be :"platformer.iso_currency_code[]" }
    end
  end
end
