# frozen_string_literal: true

require "spec_helper"

RSpec.describe Platformer::Composers::Migrations::Columns::Integer do
  describe "for a User Model which has a integer column named my_integer" do
    before(:each) do
      scaffold do
        model_for "Users::User" do
          database :postgres, :primary
          integer_field :my_integer
        end
      end
    end

    subject {
      Platformer::Databases.server(:postgres, :primary).default_database.structure.configured_schema(:public).table(:users)
    }

    context "creates the expected columns within the DynamicMigrations table" do
      it { expect(subject.has_column?(:my_integer)).to be true }

      it { expect(subject.column(:my_integer).data_type).to be :integer }

      it { expect(subject.column(:my_integer).null).to be false }

      it { expect(subject.column(:my_integer).description).to be_nil }

      it { expect(subject.column(:my_integer).default).to be_nil }
    end
  end

  describe "for a User Model which has a integer column named my_integer that has a default value, allows null and has a comment" do
    before(:each) do
      scaffold do
        model_for "Users::User" do
          database :postgres, :primary
          integer_field :my_integer do
            allow_null
            comment "This is a comment"
            default 88
          end
        end
      end
    end

    subject {
      Platformer::Databases.server(:postgres, :primary).default_database.structure.configured_schema(:public).table(:users)
    }

    context "creates the expected columns within the DynamicMigrations table" do
      it { expect(subject.has_column?(:my_integer)).to be true }

      it { expect(subject.column(:my_integer).data_type).to be :integer }

      it { expect(subject.column(:my_integer).null).to be true }

      it { expect(subject.column(:my_integer).description).to eq "This is a comment" }

      it { expect(subject.column(:my_integer).default).to eq "88" }
    end
  end

  describe "for a User Model which has a integer column marked as bigint" do
    before(:each) do
      scaffold do
        model_for "Users::User" do
          database :postgres, :primary
          integer_field :my_integer, bigint: true
        end
      end
    end

    subject {
      Platformer::Databases.server(:postgres, :primary).default_database.structure.configured_schema(:public).table(:users)
    }

    context "creates a bigint column" do
      it { expect(subject.column(:my_integer).data_type).to be :bigint }
    end
  end

  describe "for a User Model with an array of integers column named my_integer" do
    before(:each) do
      scaffold do
        model_for "Users::User" do
          database :postgres, :primary
          integer_field :my_integer, array: true
        end
      end
    end

    subject {
      Platformer::Databases.server(:postgres, :primary).default_database.structure.configured_schema(:public).table(:users)
    }

    context "creates the expected columns within the DynamicMigrations table" do
      it { expect(subject.has_column?(:my_integer)).to be true }

      it { expect(subject.column(:my_integer).data_type).to be :"integer[]" }
    end
  end
end
