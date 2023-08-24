# frozen_string_literal: true

require "spec_helper"

RSpec.describe Platformer::Composers::Migrations::Coercions::Fields::Json do
  describe "for a new UserModel which defines a simple new model, json column and an empty_json_to_null coercion" do
    before(:each) do
      create_class "Users::UserModel", PlatformModel do
        database :postgres, :primary
        json_field :json_field do
          empty_json_to_null
        end
      end
    end

    it "creates the expected validations for the DynamicMigrations table" do
      # now that the UserModel has been created, we rerun the composer
      # and it's dependent composers
      Platformer::Composers::Migrations::CreateStructure.rerun
      Platformer::Composers::Migrations::Columns::JsonColumns.rerun
      Platformer::Composers::Migrations::Coercions::Fields::Json.rerun

      table = Platformer::Databases.server(:postgres, :primary).default_database.structure.configured_schema(:public).table(:users)

      expect(table.validation(:json_field_empty_json_nulled).check_clause).to eq <<~SQL.strip
        json_field != '{}';
      SQL
    end
  end
end
