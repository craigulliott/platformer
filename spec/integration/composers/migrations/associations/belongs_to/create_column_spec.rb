# frozen_string_literal: true

require "spec_helper"

RSpec.describe Platformer::Composers::Migrations::Associations::BelongsTo::CreateColumn do
  describe "for a new BadgeModel which belongs to a UserModel" do
    before(:each) do
      scaffold do
        model_for "Users::User" do
          database :postgres, :primary
          uuid_field :id
        end
        model_for "Gamification::Badge" do
          database :postgres, :primary
          schema :gamification
          belongs_to :user, model: "Users::UserModel"
        end
      end
    end

    subject {
      Platformer::Databases.server(:postgres, :primary).default_database.structure.configured_schema(:gamification).table(:badges)
    }

    context "creates the expected column on the local table" do
      it { expect(subject.has_column?(:user_id)).to be true }
    end
  end
end
