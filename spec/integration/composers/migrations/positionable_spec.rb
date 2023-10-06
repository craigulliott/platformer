# frozen_string_literal: true

require "spec_helper"

RSpec.describe Platformer::Composers::Migrations::Positionable do
  describe "for a new PhotoModel which defines a simple new model with a positionable column" do
    before(:each) do
      scaffold do
        model_for "Users::Photo" do
          database :postgres, :primary
          uuid_field :user_id
          positionable scope: [:user_id]
        end
      end
    end

    subject {
      Platformer::Databases.server(:postgres, :primary).default_database.structure.configured_schema(:public).table(:photos)
    }

    it "creates the expected column DynamicMigrations" do
      expect(subject.column(:position).data_type).to eq :integer
    end

    it "creates the expected unique constraint in DynamicMigrations" do
      expect(subject.unique_constraint(:positionable_uniq).column_names).to eql [:user_id, :position]
    end
  end
end
