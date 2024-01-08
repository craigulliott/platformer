# frozen_string_literal: true

require "spec_helper"

RSpec.describe Platformer::Composers::Migrations::CreateStructure do
  describe "for a new UserModel which defines a simple new model in a postgres database and schema" do
    before(:each) do
      scaffold do
        model_for "Users::User" do
          database :postgres, :primary
          schema :users
        end
      end
    end

    subject {
      Platformer::Databases.server(:postgres, :primary).default_database.structure
    }

    it "creates the expected table object in the database structure" do
      expect(subject.configured_schema(:users).has_table?(:users)).to be true
    end
  end
end
