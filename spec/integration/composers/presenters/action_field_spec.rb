# frozen_string_literal: true

require "spec_helper"

RSpec.describe Platformer::Composers::Presenters::ActionField do
  describe "for a new PhotoModel which defines a simple new model with an action field" do
    before(:each) do
      scaffold do
        table_for "Users::Photo" do
          add_column :unpublished, :boolean, null: true
          add_column :published_at, :timestamp, null: true
        end
        model_for "Users::Photo" do
          database :postgres, :primary
          schema :users
          action_field :published, action_name: :publish
        end
      end
    end

    subject {
      photo = Users::Photo.create!
      photo.publish!
      Presenters::Users::Photo.new photo
    }

    context "creates the expected Presenter class" do
      it { expect(subject).to be_a Presenters::Base }

      it { expect(subject.published).to eq true }

      it { expect(subject.unpublished).to eq false }

      it { expect(subject.published_at.to_s).to eq "2023-07-14 17:00:00 UTC" }
    end
  end
end
