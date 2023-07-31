# frozen_string_literal: true

require "spec_helper"

RSpec.describe Platformer::Composers::Migrations::CreateStructure do
  describe "for a new UserModel which defines a simple new model in a postgres database and schema" do
    before(:each) do
      create_class "Users::UserModel", PlatformModel do
        database :postgres, :primary
        schema :users
      end
    end

    it "creates the expected table object in the database structure" do
      # now that the UserModel has been created, we rerun the composer
      Platformer::Composers::Migrations::CreateStructure.rerun

      expect(Platformer::Databases.server(:postgres, :primary).default_database.structure.configured_schema(:users).has_table?(:users)).to be true
    end
  end
end
