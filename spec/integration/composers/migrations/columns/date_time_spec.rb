# frozen_string_literal: true

require "spec_helper"

RSpec.describe Platformer::Composers::Migrations::Columns::DateTime do
  describe "for a User Model which has a date_time column named my_date_time" do
    before(:each) do
      scaffold do
        model_for "Users::User" do
          database :postgres, :primary
          date_time_field :my_date_time
        end
      end
    end

    subject {
      Platformer::Databases.server(:postgres, :primary).default_database.structure.configured_schema(:public).table(:users)
    }

    context "creates the expected columns within the DynamicMigrations table" do
      it { expect(subject.has_column?(:my_date_time)).to be true }

      it { expect(subject.column(:my_date_time).data_type).to be :timestamp }

      it { expect(subject.column(:my_date_time).null).to be false }

      it { expect(subject.column(:my_date_time).description).to be_nil }

      it { expect(subject.column(:my_date_time).default).to be_nil }
    end
  end

  describe "for a User Model which has a date_time column named my_date_time that has a default value, allows null and has a comment" do
    before(:each) do
      scaffold do
        model_for "Users::User" do
          database :postgres, :primary
          date_time_field :my_date_time do
            allow_null
            comment "This is a comment"
            default "1984-07-14 08:08:08"
          end
        end
      end
    end

    subject {
      Platformer::Databases.server(:postgres, :primary).default_database.structure.configured_schema(:public).table(:users)
    }

    context "creates the expected columns within the DynamicMigrations table" do
      it { expect(subject.has_column?(:my_date_time)).to be true }

      it { expect(subject.column(:my_date_time).data_type).to be :timestamp }

      it { expect(subject.column(:my_date_time).null).to be true }

      it { expect(subject.column(:my_date_time).description).to eq "This is a comment" }

      it { expect(subject.column(:my_date_time).default).to eq "1984-07-14 08:08:08" }
    end
  end

  describe "for a User Model with an array of date_times column named my_date_time" do
    before(:each) do
      scaffold do
        model_for "Users::User" do
          database :postgres, :primary
          date_time_field :my_date_time, array: true
        end
      end
    end

    subject {
      Platformer::Databases.server(:postgres, :primary).default_database.structure.configured_schema(:public).table(:users)
    }

    context "creates the expected columns within the DynamicMigrations table" do
      it { expect(subject.has_column?(:my_date_time)).to be true }

      it { expect(subject.column(:my_date_time).data_type).to be :"timestamp[]" }
    end
  end
end
