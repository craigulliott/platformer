# frozen_string_literal: true

require "spec_helper"

RSpec.describe Platformer::Composers::Migrations::StateMachines do
  describe "for a new PhotoModel which defines a simple new model numeric columns and each type of numeric validation" do
    before(:each) do
      create_class "PhotoModel", Platformer::BaseModel do
        database :postgres, :primary
        state_machine do
          state :new
          state :published

          action :publish, from: :new, to: :published
        end
      end
    end

    it "creates the expected column and enum in DynamicMigrations" do
      # now that the PhotoModel has been created, we rerun the composer
      # and it's dependent composers
      Platformer::Composers::Migrations::CreateStructure.rerun
      Platformer::Composers::Migrations::StateMachines.rerun

      table = Platformer::Databases.server(:postgres, :primary).default_database.structure.configured_schema(:public).table(:photos)

      expect(table.column(:state).data_type).to eq :photos__states
    end
  end
end
