# frozen_string_literal: true

require "spec_helper"

RSpec.describe Platformer::Composers::Migrations::Columns::Email do
  describe "for a User Model which has a email column named my_email" do
    before(:each) do
      scaffold do
        model_for "Users::User" do
          database :postgres, :primary
          email_field name: :my_email
        end
      end
    end

    subject {
      Platformer::Databases.server(:postgres, :primary).default_database.structure.configured_schema(:public).table(:users)
    }

    context "creates the expected columns within the DynamicMigrations table" do
      it { expect(subject.has_column?(:my_email)).to be true }

      it { expect(subject.column(:my_email).data_type).to be :citext }

      it { expect(subject.column(:my_email).null).to be false }

      it { expect(subject.column(:my_email).description).to be_nil }

      it { expect(subject.column(:my_email).default).to be_nil }
    end
  end

  describe "for a User Model which has a email column named my_email that has a default value, allows null and has a description" do
    before(:each) do
      scaffold do
        model_for "Users::User" do
          database :postgres, :primary
          email_field name: :my_email, allow_null: true do
            description "This is a description"
            database_default "katy@socialkaty.com"
          end
        end
      end
    end

    subject {
      Platformer::Databases.server(:postgres, :primary).default_database.structure.configured_schema(:public).table(:users)
    }

    context "creates the expected columns within the DynamicMigrations table" do
      it { expect(subject.has_column?(:my_email)).to be true }

      it { expect(subject.column(:my_email).data_type).to be :citext }

      it { expect(subject.column(:my_email).null).to be true }

      it { expect(subject.column(:my_email).description).to eq "This is a description" }

      it { expect(subject.column(:my_email).default).to eq "katy@socialkaty.com" }
    end
  end

  describe "for a User Model with an array of emails column named my_email" do
    before(:each) do
      scaffold do
        model_for "Users::User" do
          database :postgres, :primary
          email_field name: :my_email, array: true
        end
      end
    end

    subject {
      Platformer::Databases.server(:postgres, :primary).default_database.structure.configured_schema(:public).table(:users)
    }

    context "creates the expected columns within the DynamicMigrations table" do
      it { expect(subject.has_column?(:my_email)).to be true }

      it { expect(subject.column(:my_email).data_type).to be :"citext[]" }
    end
  end

  describe "for a User Model with an emails column without a custom name" do
    before(:each) do
      scaffold do
        model_for "Users::User" do
          database :postgres, :primary
          email_field
        end
      end
    end

    subject {
      Platformer::Databases.server(:postgres, :primary).default_database.structure.configured_schema(:public).table(:users)
    }

    context "creates the expected columns within the DynamicMigrations table" do
      it { expect(subject.has_column?(:email)).to be true }

      it { expect(subject.column(:email).data_type).to be :citext }
    end
  end
end
