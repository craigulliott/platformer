# frozen_string_literal: true

require "spec_helper"

RSpec.describe Platformer::Composers::ActiveRecord::Associations::HasMany do
  describe "for a new BadgeModel which belongs to a UserModel" do
    before(:each) do
      scaffold do
        table_for "Users::User"
        table_for "Users::Badge" do
          add_column :user_id, :uuid
        end
        model_for "Users::User" do
          database :postgres, :primary
          schema :users

          primary_key
          has_many :badges, model: "Users::BadgeModel"
        end
        model_for "Users::Badge" do
          database :postgres, :primary
          schema :users

          primary_key
        end
      end
    end

    it "adds the expected association to the Badge class" do
      user = Users::User.create
      badge = user.badges.create!
      user.reload

      expect(user.badges.map(&:id)).to eql [badge.id]
    end
  end
end
