# frozen_string_literal: true

require "spec_helper"

RSpec.describe Platformer::Composers::Migrations::SoftDeletable do
  describe "for a new PhotoModel which is soft deletable" do
    before(:each) do
      scaffold do
        model_for "Photo" do
          database :postgres, :primary
          soft_deletable
        end
      end
    end

    subject {
      Platformer::Databases.server(:postgres, :primary).default_database.structure.configured_schema(:public).table(:photos)
    }

    it "creates the expected column DynamicMigrations" do
      expect(subject.column(:deleted_at).data_type).to eq :"timestamp without time zone"
      expect(subject.column(:undeleted).data_type).to eq :boolean
    end

    it "creates the expected validation in DynamicMigrations" do
      expect(subject.validation(:soft_deletable).check_clause).to eq <<~SQL.strip
        (undeleted IS NULL AND deleted_at IS NOT NULL)
        OR (undeleted IS TRUE AND deleted_at IS NULL)
      SQL
    end
  end
end
