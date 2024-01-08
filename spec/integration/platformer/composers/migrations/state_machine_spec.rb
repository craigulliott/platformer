# frozen_string_literal: true

require "spec_helper"

RSpec.describe Platformer::Composers::Migrations::StateMachine do
  describe "for a new PhotoModel which defines a simple new model with a state machine" do
    before(:each) do
      scaffold do
        model_for "Users::Photo" do
          database :postgres, :primary
          state_machine do
            state :new
            state :published

            action :publish, from: :new, to: :published
          end
        end
      end
    end

    subject {
      Platformer::Databases.server(:postgres, :primary).default_database.structure.configured_schema(:public).table(:photos)
    }

    it "creates the expected column and enum in DynamicMigrations" do
      expect(subject.column(:state).data_type).to eq :"public.photos__states"
    end
  end
end
