# frozen_string_literal: true

require "spec_helper"

RSpec.describe Platformer::Composers::Migrations::Columns::Json do
  describe "for a User Model which has a json column named my_json" do
    before(:each) do
      scaffold do
        model_for "Users::User" do
          database :postgres, :primary
          json_field :my_json
        end
      end
    end

    subject {
      Platformer::Databases.server(:postgres, :primary).default_database.structure.configured_schema(:public).table(:users)
    }

    context "creates the expected columns within the DynamicMigrations table" do
      it { expect(subject.has_column?(:my_json)).to be true }

      it { expect(subject.column(:my_json).data_type).to be :jsonb }

      it { expect(subject.column(:my_json).null).to be false }

      it { expect(subject.column(:my_json).description).to be_nil }

      it { expect(subject.column(:my_json).default).to be_nil }
    end
  end

  describe "for a User Model which has a json column named my_json that has a default value, allows null and has a comment" do
    before(:each) do
      scaffold do
        model_for "Users::User" do
          database :postgres, :primary
          json_field :my_json do
            allow_null
            comment "This is a comment"
            default '{"name": "Yoshimi"}'
          end
        end
      end
    end

    subject {
      Platformer::Databases.server(:postgres, :primary).default_database.structure.configured_schema(:public).table(:users)
    }

    context "creates the expected columns within the DynamicMigrations table" do
      it { expect(subject.has_column?(:my_json)).to be true }

      it { expect(subject.column(:my_json).data_type).to be :jsonb }

      it { expect(subject.column(:my_json).null).to be true }

      it { expect(subject.column(:my_json).description).to eq "This is a comment" }

      it { expect(subject.column(:my_json).default).to eq '{"name": "Yoshimi"}' }
    end
  end
end
