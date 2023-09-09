# frozen_string_literal: true

require "spec_helper"

RSpec.describe Platformer::Composers::ActiveRecord::DefaultValues do
  describe "for a new PhotoModel which defines a simple new model with an field that has a default value" do
    before(:each) do
      scaffold do
        table_for "Photo" do
          add_column :foo, :text
        end
        model_for "Photo" do
          database :postgres, :primary
          text_field :foo do
            default "Hi There"
          end
        end
      end
    end

    it "sets the expected default value for the column" do
      photo = Photo.create!
      expect(photo.foo).to eq "Hi There"
    end
  end
end
