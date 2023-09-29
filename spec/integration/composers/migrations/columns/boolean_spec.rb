# frozen_string_literal: true

require "spec_helper"

RSpec.describe Platformer::Composers::Migrations::Columns::Boolean do
  describe "for a User Model which has a boolean column named my_boolean" do
    before(:each) do
      scaffold do
        model_for "Users::User" do
          database :postgres, :primary
          boolean_field :my_boolean
        end
      end
    end

    subject {
      Platformer::Databases.server(:postgres, :primary).default_database.structure.configured_schema(:public).table(:users)
    }

    context "creates the expected columns within the DynamicMigrations table" do
      it { expect(subject.has_column?(:my_boolean)).to be true }

      it { expect(subject.column(:my_boolean).data_type).to be :boolean }

      it { expect(subject.column(:my_boolean).null).to be false }

      it { expect(subject.column(:my_boolean).description).to be_nil }

      it { expect(subject.column(:my_boolean).default).to be_nil }
    end
  end

  describe "for a User Model which has a boolean column named my_boolean that has a default value, allows null and has a description" do
    before(:each) do
      scaffold do
        model_for "Users::User" do
          database :postgres, :primary
          boolean_field :my_boolean do
            allow_null
            description "This is a description"
            database_default "true"
          end
        end
      end
    end

    subject {
      Platformer::Databases.server(:postgres, :primary).default_database.structure.configured_schema(:public).table(:users)
    }

    context "creates the expected columns within the DynamicMigrations table" do
      it { expect(subject.has_column?(:my_boolean)).to be true }

      it { expect(subject.column(:my_boolean).data_type).to be :boolean }

      it { expect(subject.column(:my_boolean).null).to be true }

      it { expect(subject.column(:my_boolean).description).to eq "This is a description" }

      it { expect(subject.column(:my_boolean).default).to eq "true" }
    end
  end

  describe "for a User Model with an array of booleans column named my_boolean" do
    before(:each) do
      scaffold do
        model_for "Users::User" do
          database :postgres, :primary
          boolean_field :my_boolean, array: true
        end
      end
    end

    subject {
      Platformer::Databases.server(:postgres, :primary).default_database.structure.configured_schema(:public).table(:users)
    }

    context "creates the expected columns within the DynamicMigrations table" do
      it { expect(subject.has_column?(:my_boolean)).to be true }

      it { expect(subject.column(:my_boolean).data_type).to be :"boolean[]" }
    end
  end
end
