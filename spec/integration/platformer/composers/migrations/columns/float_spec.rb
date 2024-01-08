# frozen_string_literal: true

require "spec_helper"

RSpec.describe Platformer::Composers::Migrations::Columns::Float do
  describe "for a User Model which has a float column named my_float" do
    before(:each) do
      scaffold do
        model_for "Users::User" do
          database :postgres, :primary
          float_field :my_float
        end
      end
    end

    subject {
      Platformer::Databases.server(:postgres, :primary).default_database.structure.configured_schema(:public).table(:users)
    }

    context "creates the expected columns within the DynamicMigrations table" do
      it { expect(subject.has_column?(:my_float)).to be true }

      it { expect(subject.column(:my_float).data_type).to be :real }

      it { expect(subject.column(:my_float).null).to be false }

      it { expect(subject.column(:my_float).description).to be_nil }

      it { expect(subject.column(:my_float).default).to be_nil }
    end
  end

  describe "for a User Model which has a float column named my_float that has a default value, allows null and has a description" do
    before(:each) do
      scaffold do
        model_for "Users::User" do
          database :postgres, :primary
          float_field :my_float, allow_null: true do
            description "This is a description"
            database_default "8.88"
          end
        end
      end
    end

    subject {
      Platformer::Databases.server(:postgres, :primary).default_database.structure.configured_schema(:public).table(:users)
    }

    context "creates the expected columns within the DynamicMigrations table" do
      it { expect(subject.has_column?(:my_float)).to be true }

      it { expect(subject.column(:my_float).data_type).to be :real }

      it { expect(subject.column(:my_float).null).to be true }

      it { expect(subject.column(:my_float).description).to eq "This is a description" }

      it { expect(subject.column(:my_float).default).to eq "8.88" }
    end
  end

  describe "for a User Model with an array of floats column named my_float" do
    before(:each) do
      scaffold do
        model_for "Users::User" do
          database :postgres, :primary
          float_field :my_float, array: true
        end
      end
    end

    subject {
      Platformer::Databases.server(:postgres, :primary).default_database.structure.configured_schema(:public).table(:users)
    }

    context "creates the expected columns within the DynamicMigrations table" do
      it { expect(subject.has_column?(:my_float)).to be true }

      it { expect(subject.column(:my_float).data_type).to be :"real[]" }
    end
  end
end
