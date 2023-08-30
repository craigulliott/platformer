# frozen_string_literal: true

require "spec_helper"

RSpec.describe Platformer::Composers::Migrations::Coercions::Common::RemoveNullArrayValues do
  describe "for a new UserModel which defines a simple new model with an array of integers and a remove_null_array_values coercion" do
    before(:each) do
      create_class "Users::UserModel", Platformer::BaseModel do
        database :postgres, :primary
        integer_field :array_of_integers_field, array: true do
          remove_null_array_values
        end
      end
    end

    it "creates the expected validations for the DynamicMigrations table" do
      # now that the UserModel has been created, we rerun the composer
      # and it's dependent composers
      Platformer::Composers::Migrations::CreateStructure.rerun
      Platformer::Composers::Migrations::Columns::Integer.rerun
      Platformer::Composers::Migrations::Coercions::Common::RemoveNullArrayValues.rerun

      table = Platformer::Databases.server(:postgres, :primary).default_database.structure.configured_schema(:public).table(:users)

      expect(table.validation(:array_of_integers_field_no_null_values).check_clause).to eq <<~SQL.strip
        array_of_integers_field IS NULL OR ARRAY_POSITION(array_of_integers_field, NULL) IS NULL
      SQL
    end
  end
end
