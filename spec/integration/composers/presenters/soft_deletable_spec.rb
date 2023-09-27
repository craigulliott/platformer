# frozen_string_literal: true

require "spec_helper"

RSpec.describe Platformer::Composers::Presenters::SoftDeletable do
  describe "for a new PhotoModel which is soft deletable" do
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

    subject {
      photo = Users::Photo.create!
      photo.soft_delete
      Presenters::Users::Photo.new photo
    }

    context "creates the expected Presenter class" do
      it { expect(subject).to be_a Presenters::Base }

      it { expect(subject.deleted).to eq true }

      it { expect(subject.deleted_at.to_s).to eq "2023-07-14 17:00:00 UTC" }
    end
  end
end
