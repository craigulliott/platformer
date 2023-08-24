# frozen_string_literal: true

require "spec_helper"

RSpec.describe Platformer::Composers::Migrations::Coercions::Common::EmptyArrayToNull do
  describe "for a new UserModel which defines a simple new model with an array of integers and a empty_array_to_null coercion" do
    before(:each) do
      create_class "Users::UserModel", PlatformModel do
        database :postgres, :primary
        integer_field :array_of_integers_field, array: true do
          empty_array_to_null
        end
      end
    end

    it "creates the expected validations for the DynamicMigrations table" do
      # now that the UserModel has been created, we rerun the composer
      # and it's dependent composers
      Platformer::Composers::Migrations::CreateStructure.rerun
      Platformer::Composers::Migrations::Columns::IntegerColumns.rerun
      Platformer::Composers::Migrations::Coercions::Common::EmptyArrayToNull.rerun

      table = Platformer::Databases.server(:postgres, :primary).default_database.structure.configured_schema(:public).table(:users)

      expect(table.validation(:array_of_integers_field_empty_array_nulled).check_clause).to eq <<~SQL.strip
        array_of_integers_field IS NULL OR array_length(array_of_integers_field, 1) IS NOT NULL
      SQL
    end
  end
end
