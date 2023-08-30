# frozen_string_literal: true

require "spec_helper"

RSpec.describe Platformer::Composers::Migrations::Validations::Common::Immutable do
  describe "for a new UserModel which defines a simple new model with numeric columns and each type of immutable validation" do
    before(:each) do
      create_class "Users::UserModel", Platformer::BaseModel do
        database :postgres, :primary
        integer_field :my_integer do
          immutable
        end
        text_field :my_text do
          immutable_once_set
        end
        text_field :my_other_text do
          immutable_once_set
        end
      end
    end

    it "creates the triggers for the DynamicMigrations table" do
      # now that the UserModel has been created, we rerun the composer
      # and it's dependent composers
      Platformer::Composers::Migrations::CreateStructure.rerun
      Platformer::Composers::Migrations::Columns::Integer.rerun
      Platformer::Composers::Migrations::Columns::Text.rerun
      Platformer::Composers::Migrations::Validations::Common::Immutable.rerun

      table = Platformer::Databases.server(:postgres, :primary).default_database.structure.configured_schema(:public).table(:users)

      expect(table.triggers.count).to eql 2

      expect(table.trigger(:immutable).parameters).to eql "'my_integer'"
      expect(table.trigger(:immutable).action_condition).to eql "NEW.my_integer IS DISTINCT FROM OLD.my_integer"

      expect(table.trigger(:immutable_once_set).parameters).to eql "'my_text','my_other_text'"
      expect(table.trigger(:immutable_once_set).action_condition).to eql <<~SQL.strip
        (NEW.my_text IS DISTINCT FROM OLD.my_text AND OLD.my_text IS NOT NULL) OR (NEW.my_other_text IS DISTINCT FROM OLD.my_other_text AND OLD.my_other_text IS NOT NULL)
      SQL
    end
  end
end
