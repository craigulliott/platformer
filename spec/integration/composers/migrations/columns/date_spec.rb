# frozen_string_literal: true

require "spec_helper"

RSpec.describe Platformer::Composers::Migrations::Columns::Date do
  describe "for a User Model which has a date column named my_date" do
    before(:each) do
      scaffold do
        model_for "Users::User" do
          database :postgres, :primary
          date_field :my_date
        end
      end
    end

    subject {
      Platformer::Databases.server(:postgres, :primary).default_database.structure.configured_schema(:public).table(:users)
    }

    context "creates the expected columns within the DynamicMigrations table" do
      it { expect(subject.has_column?(:my_date)).to be true }

      it { expect(subject.column(:my_date).data_type).to be :date }

      it { expect(subject.column(:my_date).null).to be false }

      it { expect(subject.column(:my_date).description).to be_nil }

      it { expect(subject.column(:my_date).default).to be_nil }
    end
  end

  describe "for a User Model which has a date column named my_date that has a default value, allows null and has a description" do
    before(:each) do
      scaffold do
        model_for "Users::User" do
          database :postgres, :primary
          date_field :my_date do
            allow_null
            description "This is a description"
            database_default "1984-07-14"
          end
        end
      end
    end

    subject {
      Platformer::Databases.server(:postgres, :primary).default_database.structure.configured_schema(:public).table(:users)
    }

    context "creates the expected columns within the DynamicMigrations table" do
      it { expect(subject.has_column?(:my_date)).to be true }

      it { expect(subject.column(:my_date).data_type).to be :date }

      it { expect(subject.column(:my_date).null).to be true }

      it { expect(subject.column(:my_date).description).to eq "This is a description" }

      it { expect(subject.column(:my_date).default).to eq "1984-07-14" }
    end
  end

  describe "for a User Model with an array of dates column named my_date" do
    before(:each) do
      scaffold do
        model_for "Users::User" do
          database :postgres, :primary
          date_field :my_date, array: true
        end
      end
    end

    subject {
      Platformer::Databases.server(:postgres, :primary).default_database.structure.configured_schema(:public).table(:users)
    }

    context "creates the expected columns within the DynamicMigrations table" do
      it { expect(subject.has_column?(:my_date)).to be true }

      it { expect(subject.column(:my_date).data_type).to be :"date[]" }
    end
  end
end
