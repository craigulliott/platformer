# frozen_string_literal: true

require "spec_helper"

RSpec.describe Platformer::Composers::ActiveRecord::Associations::HasOne do
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

          uuid_field :id
          has_one :badge, model: "Users::BadgeModel"
        end
        model_for "Users::Badge" do
          database :postgres, :primary
          schema :users

          uuid_field :id
        end
      end
    end

    it "adds the expected association to the Badge class" do
      user = Users::User.create
      badge = Users::Badge.create user_id: user.id

      badge.reload
      user.reload

      expect(user.badge).to eq badge
    end
  end
end
