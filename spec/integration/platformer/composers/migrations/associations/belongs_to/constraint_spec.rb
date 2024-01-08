# frozen_string_literal: true

require "spec_helper"

RSpec.describe Platformer::Composers::Migrations::Associations::BelongsTo::Constraint do
  describe "for a new BadgeModel which belongs to a UserModel" do
    before(:each) do
      scaffold do
        model_for "Users::User" do
          database :postgres, :primary
          primary_key
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

    context "generates the expected foreign key constraint on the local table" do
      it { expect(subject.has_foreign_key_constraint?(:badges_belongs_to_user_fk)).to be true }
    end
  end

  describe "for a new FooModel which belongs to a BarModel with custom local and foreign columns" do
    before(:each) do
      scaffold do
        model_for "SchemaName::Bar" do
          database :postgres, :primary
          uuid_field :a_id
          uuid_field :b_id
        end
        model_for "SchemaName::Foo" do
          database :postgres, :primary
          uuid_field :a_id
          uuid_field :b_id
          belongs_to :bar, model: "SchemaName::BarModel", local_columns: [:a_id, :b_id], foreign_columns: [:a_id, :b_id]
        end
      end
    end

    describe "the foreign table" do
      subject {
        Platformer::Databases.server(:postgres, :primary).default_database.structure.configured_schema(:public).table(:foos)
      }

      it "generates the foreign key constraint on the foreign table" do
        expect(subject.has_foreign_key_constraint?(:foos_belongs_to_bar_fk)).to be true
      end
    end

    describe "the local table" do
      subject {
        Platformer::Databases.server(:postgres, :primary).default_database.structure.configured_schema(:public).table(:bars)
      }

      it "automatically creates a unique constraint (usable index) on the local table" do
        expect(subject.has_unique_constraint?(:foos_belongs_to_bar_uq)).to be true
      end

      it "automatically creates a unique constraint with the expected columns on the foreign table" do
        expect(subject.unique_constraint(:foos_belongs_to_bar_uq).column_names).to eql [:a_id, :b_id]
      end
    end
  end
end
