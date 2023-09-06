# frozen_string_literal: true

require "spec_helper"

RSpec.describe Platformer::Composers::Migrations::PrimaryKey do
  describe "for a new PhotoModel which defines a simple new model with a positionable column" do
    before(:each) do
      scaffold do
        model_for "Photo" do
          database :postgres, :primary
          primary_key
        end
      end
    end

    subject {
      Platformer::Databases.server(:postgres, :primary).default_database.structure.configured_schema(:public).table(:photos)
    }

    it "creates the expected column DynamicMigrations" do
      expect(subject.column(:id).data_type).to eq :uuid
    end

    it "creates the expected primary key in DynamicMigrations" do
      expect(subject.primary_key.column_names).to eql [:id]
    end
  end
end
