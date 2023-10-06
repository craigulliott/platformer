# frozen_string_literal: true

require "spec_helper"

RSpec.describe Platformer::Composers::Migrations::ActionField do
  describe "for a new PhotoModel which defines a simple new model with a action_field column" do
    before(:each) do
      scaffold do
        model_for "Users::Photo" do
          database :postgres, :primary
          action_field :published, action_name: :publish
        end
      end
    end

    subject {
      Platformer::Databases.server(:postgres, :primary).default_database.structure.configured_schema(:public).table(:photos)
    }

    it "creates the expected column DynamicMigrations" do
      expect(subject.column(:published_at).data_type).to eq :"timestamp without time zone"
      expect(subject.column(:unpublished).data_type).to eq :boolean
    end

    it "creates the expected validation in DynamicMigrations" do
      expect(subject.validation(:published_action_field).check_clause).to eq <<~SQL.strip
        (unpublished IS NULL AND published_at IS NOT NULL)
        OR (unpublished IS TRUE AND published_at IS NULL)
      SQL
    end
  end
end
