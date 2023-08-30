# frozen_string_literal: true

require "spec_helper"

RSpec.describe Platformer::Composers::Migrations::UniqueConstraints do
  describe "for a new UserModel which defines a simple new model numeric columns and each type of numeric validation" do
    before(:each) do
      create_class "Users::UserModel", Platformer::BaseModel do
        database :postgres, :primary
        integer_field :my_integer do
          unique
        end
        float_field :my_float do
          unique scope: :my_integer
        end
        numeric_field :my_numeric do
          unique scope: [:my_float, :my_integer], deferrable: true
        end
        double_field :my_double do
          unique comment: "Test description"
        end
        double_field :my_text do
          unique scope: [:my_float, :my_integer], where: "my_integer > 0"
        end
      end
    end

    it "creates the expected unique constraint for the DynamicMigrations table" do
      # now that the UserModel has been created, we rerun the composer
      # and it's dependent composers
      Platformer::Composers::Migrations::CreateStructure.rerun
      Platformer::Composers::Migrations::Columns::Integer.rerun
      Platformer::Composers::Migrations::Columns::Float.rerun
      Platformer::Composers::Migrations::Columns::Numeric.rerun
      Platformer::Composers::Migrations::Columns::Double.rerun
      Platformer::Composers::Migrations::UniqueConstraints.rerun

      table = Platformer::Databases.server(:postgres, :primary).default_database.structure.configured_schema(:public).table(:users)

      expect(table.unique_constraint(:public_users_my_integer_uniq).column_names).to eql [:my_integer]
      # deferrable should be false by default
      expect(table.unique_constraint(:public_users_my_float_my_integer_uniq).deferrable).to be false

      expect(table.unique_constraint(:public_users_my_float_my_integer_uniq).column_names).to eql [:my_float, :my_integer]

      expect(table.unique_constraint(:public_users_my_numeric_my_float_my_integer_uniq).column_names).to eql [:my_numeric, :my_float, :my_integer]
      expect(table.unique_constraint(:public_users_my_numeric_my_float_my_integer_uniq).deferrable).to be true

      expect(table.unique_constraint(:public_users_my_double_uniq).column_names).to eql [:my_double]
      expect(table.unique_constraint(:public_users_my_double_uniq).description).to eq "Test description"

      expect(table.index(:public_users_my_text_my_float_my_integer_uniq).column_names).to eql [:my_text, :my_float, :my_integer]
      expect(table.index(:public_users_my_text_my_float_my_integer_uniq).where).to eq "my_integer > 0"
    end
  end
end
