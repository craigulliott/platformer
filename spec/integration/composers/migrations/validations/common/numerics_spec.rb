# frozen_string_literal: true

require "spec_helper"

RSpec.describe Platformer::Composers::Migrations::Validations::Common::Numerics do
  describe "for a new UserModel which defines a simple new model with numeric columns and each type of numeric validation" do
    before(:each) do
      create_class "Users::UserModel", PlatformModel do
        database :postgres, :primary
        integer_field :my_integer do
          validate_greater_than 0
        end
        float_field :my_float do
          validate_greater_than_or_equal_to 0
        end
        numeric_field :my_numeric do
          validate_less_than 10
        end
        double_field :my_double do
          validate_less_than_or_equal_to 10
        end
      end
    end

    it "creates the expected validations for the DynamicMigrations table" do
      # now that the UserModel has been created, we rerun the composer
      # and it's dependent composers
      Platformer::Composers::Migrations::CreateStructure.rerun
      Platformer::Composers::Migrations::Columns::Integer.rerun
      Platformer::Composers::Migrations::Columns::Float.rerun
      Platformer::Composers::Migrations::Columns::Numeric.rerun
      Platformer::Composers::Migrations::Columns::Double.rerun
      Platformer::Composers::Migrations::Validations::Common::Numerics.rerun

      table = Platformer::Databases.server(:postgres, :primary).default_database.structure.configured_schema(:public).table(:users)

      expect(table.has_validation?(:my_integer_gt)).to be true
      expect(table.has_validation?(:my_float_gte)).to be true
      expect(table.has_validation?(:my_numeric_lt)).to be true
      expect(table.has_validation?(:my_double_lte)).to be true
    end
  end
end
