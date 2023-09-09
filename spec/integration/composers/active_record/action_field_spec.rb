# frozen_string_literal: true

require "spec_helper"

RSpec.describe Platformer::Composers::ActiveRecord::ActionField do
  describe "for a new PhotoModel which defines a simple new model with an action field" do
    before(:each) do
      scaffold do
        table_for "Photo" do
          add_column :unpublished, :boolean, null: true
          add_column :published_at, :timestamp, null: true
        end
        model_for "Photo" do
          database :postgres, :primary
          action_field :published, action_name: :publish
        end
      end
    end

    it "creates the expected action on the active record model" do
      photo = Photo.create!
      expect(photo.unpublished).to be true
      expect(photo.published_at).to be_nil

      photo.publish
      expect(photo.unpublished).to be nil
      expect(photo.published_at).to_not be_nil
    end
  end
end
