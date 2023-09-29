# frozen_string_literal: true

require "spec_helper"

RSpec.describe Platformer::Composers::Migrations::Columns::Text do
  describe "for a User Model which has a text column named my_text" do
    before(:each) do
      scaffold do
        model_for "Users::User" do
          database :postgres, :primary
          text_field :my_text
        end
      end
    end

    subject {
      Platformer::Databases.server(:postgres, :primary).default_database.structure.configured_schema(:public).table(:users)
    }

    context "creates the expected columns within the DynamicMigrations table" do
      it { expect(subject.has_column?(:my_text)).to be true }

      it { expect(subject.column(:my_text).data_type).to be :text }

      it { expect(subject.column(:my_text).null).to be false }

      it { expect(subject.column(:my_text).description).to be_nil }

      it { expect(subject.column(:my_text).default).to be_nil }
    end
  end

  describe "for a User Model which has a text column named my_text that has a default value, allows null and has a description" do
    before(:each) do
      scaffold do
        model_for "Users::User" do
          database :postgres, :primary
          text_field :my_text do
            allow_null
            description "This is a description"
            database_default "Hi Katy!"
          end
        end
      end
    end

    subject {
      Platformer::Databases.server(:postgres, :primary).default_database.structure.configured_schema(:public).table(:users)
    }

    context "creates the expected columns within the DynamicMigrations table" do
      it { expect(subject.has_column?(:my_text)).to be true }

      it { expect(subject.column(:my_text).data_type).to be :text }

      it { expect(subject.column(:my_text).null).to be true }

      it { expect(subject.column(:my_text).description).to eq "This is a description" }

      it { expect(subject.column(:my_text).default).to eq "Hi Katy!" }
    end
  end

  describe "for a User Model which has a text column named my_text that has a max length validation" do
    before(:each) do
      scaffold do
        model_for "Users::User" do
          database :postgres, :primary
          text_field :my_text do
            validate_maximum_length 5
          end
        end
      end
    end

    subject {
      Platformer::Databases.server(:postgres, :primary).default_database.structure.configured_schema(:public).table(:users)
    }

    context "creates a varchar column" do
      it { expect(subject.column(:my_text).data_type).to be :"varchar(5)" }
    end
  end

  describe "for a User Model which has a text column named my_text that has a exact length validation" do
    before(:each) do
      scaffold do
        model_for "Users::User" do
          database :postgres, :primary
          text_field :my_text do
            validate_length_is 5
          end
        end
      end
    end

    subject {
      Platformer::Databases.server(:postgres, :primary).default_database.structure.configured_schema(:public).table(:users)
    }

    context "creates a varchar column" do
      it { expect(subject.column(:my_text).data_type).to be :"char(5)" }
    end
  end

  describe "for a User Model with an array of texts column named my_text" do
    before(:each) do
      scaffold do
        model_for "Users::User" do
          database :postgres, :primary
          text_field :my_text, array: true
        end
      end
    end

    subject {
      Platformer::Databases.server(:postgres, :primary).default_database.structure.configured_schema(:public).table(:users)
    }

    context "creates the expected columns within the DynamicMigrations table" do
      it { expect(subject.has_column?(:my_text)).to be true }

      it { expect(subject.column(:my_text).data_type).to be :"text[]" }
    end
  end
end
