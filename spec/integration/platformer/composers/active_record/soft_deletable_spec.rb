# frozen_string_literal: true

require "spec_helper"

RSpec.describe Platformer::Composers::ActiveRecord::SoftDeletable do
  describe "for a new PhotoModel which defines a simple new model with an action field" do
    before(:each) do
      scaffold do
        table_for "Users::Photo" do
          add_column :undeleted, :boolean, null: true
          add_column :deleted_at, :timestamp, null: true
        end
        model_for "Users::Photo" do
          database :postgres, :primary
          schema :users
          soft_deletable
        end
      end
    end

    it "allows soft deleting the model" do
      photo = Users::Photo.create!
      expect(photo.undeleted).to be true
      expect(photo.deleted_at).to be_nil

      photo.soft_delete
      expect(photo.undeleted).to be nil
      expect(photo.deleted_at).to_not be_nil
    end
  end
end
