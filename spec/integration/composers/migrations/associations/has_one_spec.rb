# frozen_string_literal: true

require "spec_helper"

RSpec.describe Platformer::Composers::Migrations::Associations::HasOne do
  describe "for a new BadgeModel which has one UserModel" do
    before(:each) do
      scaffold do
        model_for "Users::User" do
          database :postgres, :primary
          uuid_field :id
          has_one "Gamification::BadgeModel"
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

    context "generates the expected column and foreign key constraint on the foreign table" do
      it { expect(subject.has_foreign_key_constraint?(:has_one_from_users)).to be true }

      it { expect(subject.has_column?(:user_id)).to be true }
    end
  end

  describe "for a new FooModel which has_one BarModels with custom local and foreign columns" do
    before(:each) do
      scaffold do
        model_for "Bar" do
          database :postgres, :primary
          uuid_field :a_id
          uuid_field :b_id
        end
        model_for "Foo" do
          database :postgres, :primary
          uuid_field :a_id
          uuid_field :b_id
          has_one "BarModel", local_column_names: [:a_id, :b_id], foreign_column_names: [:a_id, :b_id]
        end
      end
    end

    subject {
      Platformer::Databases.server(:postgres, :primary).default_database.structure.configured_schema(:public).table(:bars)
    }

    it "generates the foreign key constraint on the foreign table" do
      expect(subject.has_foreign_key_constraint?(:has_one_from_foos)).to be true
    end

    it "automatically creates a usable index on the foreign table" do
      raise "todo"
    end
  end
end
