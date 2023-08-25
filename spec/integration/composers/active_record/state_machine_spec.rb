# frozen_string_literal: true

require "spec_helper"

RSpec.describe Platformer::Composers::ActiveRecord::StateMachines do
  let(:pg_helper) { RSpec.configuration.pg_spec_helper }

  before(:each) do
    create_class :TestBaseModel, PlatformModel do
      database :postgres, :primary
    end
  end

  after(:each) do
    destroy_class TestBase
  end

  describe "for a new PhotoModel which defines a simple new model with a state machine" do
    before(:each) do
      pg_helper.create_model :public, :photos do
        add_column :state, :text
      end

      # create a definition for a new Photo
      create_class "PhotoModel", TestBaseModel do
        state_machine do
          state :new
          state :published

          action :publish, from: :new, to: :published
        end
      end

      # now that the PhotoModel has been created, we rerun the relevant composers
      Platformer::Composers::ActiveRecord::CreateActiveModels.rerun
      Platformer::Composers::ActiveRecord::StateMachines.rerun
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

    after(:each) do
      destroy_class Photo
    end
  end
end
