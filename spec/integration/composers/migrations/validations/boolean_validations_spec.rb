# frozen_string_literal: true

require "spec_helper"

RSpec.describe Platformer::Composers::Migrations::Validations::BooleanValidations do
  describe "for a new UserModel which defines a simple new model, boolean columns and each type of numeric validation" do
    before(:each) do
      create_class "Users::UserModel", PlatformModel do
        database :postgres, :primary
        boolean_field :my_bool do
          # no special validations
        end
        boolean_field :my_false_bool do
          validate_is_false
        end
        boolean_field :my_true_bool do
          validate_is_true
        end
      end
    end

    it "creates the expected validations for the DynamicMigrations table" do
      # now that the UserModel has been created, we rerun the composer
      # and it's dependent composers
      Platformer::Composers::Migrations::CreateStructure.rerun
      Platformer::Composers::Migrations::Columns::BooleanColumns.rerun
      Platformer::Composers::Migrations::Validations::BooleanValidations.rerun

      table = Platformer::Databases.server(:postgres, :primary).default_database.structure.configured_schema(:public).table(:users)

      expect(table.validation(:my_false_bool_is_false).check_clause).to eq "my_false_bool IS FALSE"
      expect(table.validation(:my_true_bool_is_true).check_clause).to eq "my_true_bool IS TRUE"
    end
  end
end
