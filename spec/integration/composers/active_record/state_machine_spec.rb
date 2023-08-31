# frozen_string_literal: true

require "spec_helper"

RSpec.describe Platformer::Composers::ActiveRecord::StateMachines do
  let(:pg_helper) { RSpec.configuration.pg_spec_helper }

  describe "for a new PhotoModel which defines a simple new model with a state machine" do
    before(:each) do
      scaffold do
        table_for "Photo" do
          add_column :state, :text
        end
        model_for "Photo" do
          database :postgres, :primary
          state_machine do
            state :new
            state :published

            action :publish, from: :new, to: :published
          end
        end
      end
    end

    it "creates the expected state machine on the active record model" do
      photo = Photo.new
      expect(photo.state).to eq "new"

      photo.save!
      expect(photo.state).to eq "new"

      photo.reload
      expect(photo.state).to eq "new"

      photo.publish!
      expect(photo.state).to eq "published"

      photo.reload
      expect(photo.state).to eq "published"
    end
  end
end
