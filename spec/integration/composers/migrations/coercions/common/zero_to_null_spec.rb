# frozen_string_literal: true

require "spec_helper"

RSpec.describe Platformer::Composers::Migrations::Coercions::Common::ZeroToNull do
  describe "for a new UserModel which defines a simple new model, integer column, array of integers and a zero_to_null coercion" do
    before(:each) do
      create_class "Users::UserModel", Platformer::BaseModel do
        database :postgres, :primary
        integer_field :integer_field do
          zero_to_null
        end
        integer_field :array_of_integers_field, array: true do
          zero_to_null
        end
      end
    end

    it "creates the expected validations for the DynamicMigrations table" do
      # now that the UserModel has been created, we rerun the composer
      # and it's dependent composers
      Platformer::Composers::Migrations::CreateStructure.rerun
      Platformer::Composers::Migrations::Columns::Integer.rerun
      Platformer::Composers::Migrations::Coercions::Common::ZeroToNull.rerun

      table = Platformer::Databases.server(:postgres, :primary).default_database.structure.configured_schema(:public).table(:users)

      expect(table.validation(:integer_field_zero_nulled).check_clause).to eq <<~SQL.strip
        integer_field IS DISTINCT FROM 0
      SQL

      expect(table.validation(:array_of_integers_field_zero_nulled).check_clause).to eq <<~SQL.strip
        0 = ANY(array_of_integers_field)
      SQL
    end
  end
end
