# frozen_string_literal: true

require "spec_helper"

RSpec.describe Platformer::Composers::Migrations::Columns::Numeric do
  describe "for a User Model which has a numeric column named my_numeric" do
    before(:each) do
      scaffold do
        model_for "Users::User" do
          database :postgres, :primary
          numeric_field :my_numeric
        end
      end
    end

    subject {
      Platformer::Databases.server(:postgres, :primary).default_database.structure.configured_schema(:public).table(:users)
    }

    context "creates the expected columns within the DynamicMigrations table" do
      it { expect(subject.has_column?(:my_numeric)).to be true }

      it { expect(subject.column(:my_numeric).data_type).to be :numeric }

      it { expect(subject.column(:my_numeric).null).to be false }

      it { expect(subject.column(:my_numeric).description).to be_nil }

      it { expect(subject.column(:my_numeric).default).to be_nil }
    end
  end

  describe "for a User Model which has a numeric column named my_numeric that has a default value, allows null and has a comment" do
    before(:each) do
      scaffold do
        model_for "Users::User" do
          database :postgres, :primary
          numeric_field :my_numeric do
            allow_null
            comment "This is a comment"
            default 8.80
          end
        end
      end
    end

    subject {
      Platformer::Databases.server(:postgres, :primary).default_database.structure.configured_schema(:public).table(:users)
    }

    context "creates the expected columns within the DynamicMigrations table" do
      it { expect(subject.has_column?(:my_numeric)).to be true }

      it { expect(subject.column(:my_numeric).data_type).to be :numeric }

      it { expect(subject.column(:my_numeric).null).to be true }

      it { expect(subject.column(:my_numeric).description).to eq "This is a comment" }

      it { expect(subject.column(:my_numeric).default).to eq 8.80 }
    end
  end

  describe "for a User Model with an array of numerics column named my_numeric" do
    before(:each) do
      scaffold do
        model_for "Users::User" do
          database :postgres, :primary
          numeric_field :my_numeric, array: true
        end
      end
    end

    subject {
      Platformer::Databases.server(:postgres, :primary).default_database.structure.configured_schema(:public).table(:users)
    }

    context "creates the expected columns within the DynamicMigrations table" do
      it { expect(subject.has_column?(:my_numeric)).to be true }

      it { expect(subject.column(:my_numeric).data_type).to be :"numeric[]" }
    end
  end
end
