# frozen_string_literal: true

require "spec_helper"

RSpec.describe Platformer::Composers::Migrations::Associations::HasOne::CreateColumn do
  describe "for a new BadgeModel which has one UserModel" do
    before(:each) do
      scaffold do
        model_for "Users::User" do
          database :postgres, :primary
          primary_key
          has_one :badge, model: "Gamification::BadgeModel"
        end
        model_for "Gamification::Badge" do
          database :postgres, :primary
          schema :gamification
        end
      end
    end

    subject {
      Platformer::Databases.server(:postgres, :primary).default_database.structure.configured_schema(:gamification).table(:badges)
    }

    context "creates the expected column on the foreign table" do
      it { expect(subject.has_column?(:user_id)).to be true }
    end
  end
end
