# frozen_string_literal: true

require "spec_helper"

RSpec.describe Platformer::Composers::Migrations::Validations::NumericValidations do
  describe "for a new UserModel which defines a simple new model with an integer column in a postgres database" do
    before(:each) do
      create_class "Users::UserModel", PlatformModel do
        database :postgres, :primary
        integer_field :foo do
          validate_greater_than 0
        end
      end
    end

    it "creates the expected validations within the DynamicMigrations table" do
      # now that the UserModel has been created, we rerun the composer
      # and it's dependent composers
      Platformer::Composers::Migrations::CreateStructure.rerun
      Platformer::Composers::Migrations::Columns::IntegerColumns.rerun
      Platformer::Composers::Migrations::Validations::NumericValidations.rerun

      table = Platformer::Databases.server(:postgres, :primary).default_database.structure.configured_schema(:public).table(:users)

      expect(table.has_validation?(:public_users_foo_gt)).to be true
    end
  end
end
