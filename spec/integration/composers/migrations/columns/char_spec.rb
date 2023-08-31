# frozen_string_literal: true

require "spec_helper"

RSpec.describe Platformer::Composers::Migrations::Columns::Char do
  describe "for a User Model which has a char column named my_char" do
    before(:each) do
      scaffold do
        model_for "Users::User" do
          database :postgres, :primary
          char_field :my_char
        end
      end
    end

    subject {
      Platformer::Databases.server(:postgres, :primary).default_database.structure.configured_schema(:public).table(:users)
    }

    context "creates the expected columns within the DynamicMigrations table" do
      it { expect(subject.has_column?(:my_char)).to be true }

      it { expect(subject.column(:my_char).data_type).to be :char }

      it { expect(subject.column(:my_char).null).to be false }

      it { expect(subject.column(:my_char).description).to be_nil }

      it { expect(subject.column(:my_char).default).to be_nil }
    end
  end

  describe "for a User Model which has a char column named my_char that has a default value, allows null and has a comment" do
    before(:each) do
      scaffold do
        model_for "Users::User" do
          database :postgres, :primary
          char_field :my_char do
            allow_null
            comment "This is a comment"
            default "Hi Katy!"
          end
        end
      end
    end

    subject {
      Platformer::Databases.server(:postgres, :primary).default_database.structure.configured_schema(:public).table(:users)
    }

    context "creates the expected columns within the DynamicMigrations table" do
      it { expect(subject.has_column?(:my_char)).to be true }

      it { expect(subject.column(:my_char).data_type).to be :char }

      it { expect(subject.column(:my_char).null).to be true }

      it { expect(subject.column(:my_char).description).to eq "This is a comment" }

      it { expect(subject.column(:my_char).default).to eq "Hi Katy!" }
    end
  end

  describe "for a User Model with an array of chars column named my_char" do
    before(:each) do
      scaffold do
        model_for "Users::User" do
          database :postgres, :primary
          char_field :my_char, array: true
        end
      end
    end

    subject {
      Platformer::Databases.server(:postgres, :primary).default_database.structure.configured_schema(:public).table(:users)
    }

    context "creates the expected columns within the DynamicMigrations table" do
      it { expect(subject.has_column?(:my_char)).to be true }

      it { expect(subject.column(:my_char).data_type).to be :"char[]" }
    end
  end
end
