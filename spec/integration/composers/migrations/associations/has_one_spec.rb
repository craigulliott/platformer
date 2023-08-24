# frozen_string_literal: true

require "spec_helper"

RSpec.describe Platformer::Composers::Migrations::Associations::HasOne do
  describe "for a new BadgeModel which has one UserModel" do
    before(:each) do
      create_class "Users::UserModel", PlatformModel do
        database :postgres, :primary
        uuid_field :id
        has_one "Gamification::BadgeModel"
      end
      create_class "Gamification::BadgeModel", PlatformModel do
        database :postgres, :primary
        schema :gamification
      end
    end

    it "generates the expected column and foreign key constraint on the foreign table" do
      # now that the UserModel has been created, we rerun the composer
      # and it's dependent composers
      Platformer::Composers::Migrations::CreateStructure.rerun
      Platformer::Composers::Migrations::Columns::UuidColumns.rerun
      Platformer::Composers::Migrations::Associations::HasOne.rerun

      badges_table = Platformer::Databases.server(:postgres, :primary).default_database.structure.configured_schema(:gamification).table(:badges)

      expect(badges_table.has_foreign_key_constraint?(:has_one_from_users)).to be true
      expect(badges_table.has_column?(:user_id)).to be true
    end
  end

  describe "for a new FooModel which has_one BarModels with custom local and foreign columns" do
    before(:each) do
      create_class "BarModel", PlatformModel do
        database :postgres, :primary
        uuid_field :a_id
        uuid_field :b_id
      end
      create_class "FooModel", PlatformModel do
        database :postgres, :primary
        uuid_field :a_id
        uuid_field :b_id
        has_one "BarModel", local_column_names: [:a_id, :b_id], foreign_column_names: [:a_id, :b_id]
      end
    end

    it "generates the foreign key constraint on the foreign table" do
      # now that the BarModel has been created, we rerun the composer
      # and it's dependent composers
      Platformer::Composers::Migrations::CreateStructure.rerun
      Platformer::Composers::Migrations::Columns::UuidColumns.rerun
      Platformer::Composers::Migrations::Associations::HasOne.rerun

      bar_table = Platformer::Databases.server(:postgres, :primary).default_database.structure.configured_schema(:public).table(:bars)

      expect(bar_table.has_foreign_key_constraint?(:has_one_from_foos)).to be true
    end

    it "automatically creates a usable index on the foreign table" do
      # now that the BarModel has been created, we rerun the composer
      # and it's dependent composers
      Platformer::Composers::Migrations::CreateStructure.rerun
      Platformer::Composers::Migrations::Columns::UuidColumns.rerun
      Platformer::Composers::Migrations::Associations::HasOne.rerun

      local_table = Platformer::Databases.server(:postgres, :primary).default_database.structure.configured_schema(:public).table(:foos)

      raise "todo"
    end
  end
end
