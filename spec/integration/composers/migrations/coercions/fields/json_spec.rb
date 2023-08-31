# frozen_string_literal: true

require "spec_helper"

RSpec.describe Platformer::Composers::Migrations::Coercions::Fields::Json do
  describe "for a new UserModel which defines a simple new model, json column and an empty_json_to_null coercion" do
    before(:each) do
      scaffold do
        model_for "Users::User" do
          database :postgres, :primary
          json_field :json_field do
            empty_json_to_null
          end
        end
      end
    end

    subject {
      Platformer::Databases.server(:postgres, :primary).default_database.structure.configured_schema(:public).table(:users)
    }

    it "creates the expected validations for the DynamicMigrations table" do
      expect(subject.validation(:json_field_empty_json_nulled).check_clause).to eq <<~SQL.strip
        json_field != '{}';
      SQL
    end
  end
end
