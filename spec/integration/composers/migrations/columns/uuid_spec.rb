# frozen_string_literal: true

require "spec_helper"

RSpec.describe Platformer::Composers::Migrations::Columns::Uuid do
  describe "for a User Model which has a uuid column named my_uuid" do
    before(:each) do
      scaffold do
        model_for "Users::User" do
          database :postgres, :primary
          uuid_field :my_uuid
        end
      end
    end

    subject {
      Platformer::Databases.server(:postgres, :primary).default_database.structure.configured_schema(:public).table(:users)
    }

    context "creates the expected columns within the DynamicMigrations table" do
      it { expect(subject.has_column?(:my_uuid)).to be true }

      it { expect(subject.column(:my_uuid).data_type).to be :uuid }

      it { expect(subject.column(:my_uuid).null).to be false }

      it { expect(subject.column(:my_uuid).description).to be_nil }

      it { expect(subject.column(:my_uuid).default).to be_nil }
    end
  end

  describe "for a User Model which has a uuid column named my_uuid that has a default value, allows null and has a comment" do
    before(:each) do
      scaffold do
        model_for "Users::User" do
          database :postgres, :primary
          uuid_field :my_uuid do
            allow_null
            comment "This is a comment"
            default "63510e31-bbf8-49e0-9878-ce2a974ead54"
          end
        end
      end
    end

    subject {
      Platformer::Databases.server(:postgres, :primary).default_database.structure.configured_schema(:public).table(:users)
    }

    context "creates the expected columns within the DynamicMigrations table" do
      it { expect(subject.has_column?(:my_uuid)).to be true }

      it { expect(subject.column(:my_uuid).data_type).to be :uuid }

      it { expect(subject.column(:my_uuid).null).to be true }

      it { expect(subject.column(:my_uuid).description).to eq "This is a comment" }

      it { expect(subject.column(:my_uuid).default).to eq "63510e31-bbf8-49e0-9878-ce2a974ead54" }
    end
  end

  describe "for a User Model with an array of uuids column named my_uuid" do
    before(:each) do
      scaffold do
        model_for "Users::User" do
          database :postgres, :primary
          uuid_field :my_uuid, array: true
        end
      end
    end

    subject {
      Platformer::Databases.server(:postgres, :primary).default_database.structure.configured_schema(:public).table(:users)
    }

    context "creates the expected columns within the DynamicMigrations table" do
      it { expect(subject.has_column?(:my_uuid)).to be true }

      it { expect(subject.column(:my_uuid).data_type).to be :"uuid[]" }
    end
  end
end
