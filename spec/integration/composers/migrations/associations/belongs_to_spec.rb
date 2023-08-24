# frozen_string_literal: true

require "spec_helper"

RSpec.describe Platformer::Composers::Migrations::Associations::BelongsTo do
  describe "for a new BadgeModel which belongs to a UserModel" do
    before(:each) do
      create_class "Users::UserModel", PlatformModel do
        database :postgres, :primary
        uuid_field :id
      end
      create_class "Gamification::BadgeModel", PlatformModel do
        database :postgres, :primary
        schema :gamification
        belongs_to "Users::UserModel"
      end
    end

    it "generates the expected column and foreign key constraint on the local table" do
      # now that the UserModel has been created, we rerun the composer
      # and it's dependent composers
      Platformer::Composers::Migrations::CreateStructure.rerun
      Platformer::Composers::Migrations::Columns::UuidColumns.rerun
      Platformer::Composers::Migrations::Associations::BelongsTo.rerun

      local_table = Platformer::Databases.server(:postgres, :primary).default_database.structure.configured_schema(:gamification).table(:badges)

      expect(local_table.has_foreign_key_constraint?(:association_to_users)).to be true
      expect(local_table.has_column?(:user_id)).to be true
    end
  end

  describe "for a new FooModel which belongs to a BarModel with custom local and foreign columns" do
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
        belongs_to "BarModel", local_column_names: [:a_id, :b_id], foreign_column_names: [:a_id, :b_id]
      end
    end

    it "generates the foreign key constraint on the local table" do
      # now that the BarModel has been created, we rerun the composer
      # and it's dependent composers
      Platformer::Composers::Migrations::CreateStructure.rerun
      Platformer::Composers::Migrations::Columns::UuidColumns.rerun
      Platformer::Composers::Migrations::Associations::BelongsTo.rerun

      local_table = Platformer::Databases.server(:postgres, :primary).default_database.structure.configured_schema(:public).table(:foos)

      expect(local_table.has_foreign_key_constraint?(:association_to_bars)).to be true
    end

    it "automatically creates a usable index on the foreign table" do
      # now that the BarModel has been created, we rerun the composer
      # and it's dependent composers
      Platformer::Composers::Migrations::CreateStructure.rerun
      Platformer::Composers::Migrations::Columns::UuidColumns.rerun
      Platformer::Composers::Migrations::Associations::BelongsTo.rerun

      local_table = Platformer::Databases.server(:postgres, :primary).default_database.structure.configured_schema(:public).table(:foos)

      raise "todo"
    end
  end
end
