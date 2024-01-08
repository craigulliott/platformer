# frozen_string_literal: true

require "spec_helper"

RSpec.describe Platformer::Composers::Migrations::Coercions::Common::RemoveNullArrayValues do
  describe "for a new UserModel which defines a simple new model with an array of integers and a remove_null_array_values coercion" do
    before(:each) do
      scaffold do
        model_for "Users::User" do
          database :postgres, :primary
          integer_field :array_of_integers_field, array: true do
            remove_null_array_values
          end
        end
      end
    end

    subject {
      Platformer::Databases.server(:postgres, :primary).default_database.structure.configured_schema(:public).table(:users)
    }

    it "creates the expected validations for the DynamicMigrations table" do
      expect(subject.validation(:array_of_integers_field_no_null_values).check_clause).to eq <<~SQL.strip
        array_of_integers_field IS NULL OR ARRAY_POSITION(array_of_integers_field, NULL) IS NULL
      SQL
    end
  end
end
