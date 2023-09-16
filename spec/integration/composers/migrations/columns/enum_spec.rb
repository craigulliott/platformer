# frozen_string_literal: true

require "spec_helper"

RSpec.describe Platformer::Composers::Migrations::Columns::Enum do
  describe "for a User Model which has a enum column named my_enum" do
    before(:each) do
      scaffold do
        model_for "Users::User" do
          database :postgres, :primary
          enum_field :my_enum, ["foo", "bar"]
        end
      end
    end

    subject {
      Platformer::Databases.server(:postgres, :primary).default_database.structure.configured_schema(:public).table(:users)
    }

    context "creates the expected columns within the DynamicMigrations table" do
      it { expect(subject.has_column?(:my_enum)).to be true }

      it { expect(subject.column(:my_enum).data_type).to be :"public.users__my_enum_values" }

      it { expect(subject.column(:my_enum).null).to be false }

      it { expect(subject.column(:my_enum).description).to be_nil }

      it { expect(subject.column(:my_enum).default).to be_nil }
    end
  end

  describe "for a User Model which has a enum column named my_enum that has a default value, allows null and has a comment" do
    before(:each) do
      scaffold do
        model_for "Users::User" do
          database :postgres, :primary
          enum_field :my_enum, ["foo", "bar"] do
            allow_null
            comment "This is a comment"
            default "foo"
          end
        end
      end
    end

    subject {
      Platformer::Databases.server(:postgres, :primary).default_database.structure.configured_schema(:public).table(:users)
    }

    context "creates the expected columns within the DynamicMigrations table" do
      it { expect(subject.has_column?(:my_enum)).to be true }

      it { expect(subject.column(:my_enum).data_type).to be :"public.users__my_enum_values" }

      it { expect(subject.column(:my_enum).null).to be true }

      it { expect(subject.column(:my_enum).description).to eq "This is a comment" }

      it { expect(subject.column(:my_enum).default).to eq "foo" }
    end
  end

  describe "for a User Model with an array of enums column named my_enum" do
    before(:each) do
      scaffold do
        model_for "Users::User" do
          database :postgres, :primary
          enum_field :my_enum, ["foo", "bar"], array: true
        end
      end
    end

    subject {
      Platformer::Databases.server(:postgres, :primary).default_database.structure.configured_schema(:public).table(:users)
    }

    context "creates the expected columns within the DynamicMigrations table" do
      it { expect(subject.has_column?(:my_enum)).to be true }

      it { expect(subject.column(:my_enum).data_type).to be :"public.users__my_enum_values[]" }
    end
  end
end
