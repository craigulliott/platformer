# frozen_string_literal: true

require "spec_helper"

RSpec.describe Platformer::Composers::Migrations::Associations::HasMany do
  describe "for a new BadgeModel which has many UserModels" do
    before(:each) do
      create_class "Users::UserModel", Platformer::BaseModel do
        database :postgres, :primary
        uuid_field :id
        has_many "Gamification::BadgeModel"
      end
      create_class "Gamification::BadgeModel", Platformer::BaseModel do
        database :postgres, :primary
        schema :gamification
      end
    end

    it "generates the expected column and foreign key constraint on the foreign table" do
      # now that the UserModel has been created, we rerun the composer
      # and it's dependent composers
      Platformer::Composers::Migrations::CreateStructure.rerun
      Platformer::Composers::Migrations::Columns::Uuid.rerun
      Platformer::Composers::Migrations::Associations::HasMany.rerun

      badges_table = Platformer::Databases.server(:postgres, :primary).default_database.structure.configured_schema(:gamification).table(:badges)

      expect(badges_table.has_foreign_key_constraint?(:has_many_from_users)).to be true
      expect(badges_table.has_column?(:user_id)).to be true
    end
  end

  describe "for a new FooModel which has_many BarModels with custom local and foreign columns" do
    before(:each) do
      create_class "BarModel", Platformer::BaseModel do
        database :postgres, :primary
        uuid_field :a_id
        uuid_field :b_id
      end
      create_class "FooModel", Platformer::BaseModel do
        database :postgres, :primary
        uuid_field :a_id
        uuid_field :b_id
        has_many "BarModel", local_column_names: [:a_id, :b_id], foreign_column_names: [:a_id, :b_id]
      end
    end

    it "generates the foreign key constraint on the local table" do
      # now that the BarModel has been created, we rerun the composer
      # and it's dependent composers
      Platformer::Composers::Migrations::CreateStructure.rerun
      Platformer::Composers::Migrations::Columns::Uuid.rerun
      Platformer::Composers::Migrations::Associations::HasMany.rerun

      bar_table = Platformer::Databases.server(:postgres, :primary).default_database.structure.configured_schema(:public).table(:bars)
      expect(bar_table.has_foreign_key_constraint?(:has_many_from_foos)).to be true
    end

    it "automatically creates a usable index on the foreign table" do
      # now that the BarModel has been created, we rerun the composer
      # and it's dependent composers
      Platformer::Composers::Migrations::CreateStructure.rerun
      Platformer::Composers::Migrations::Columns::Uuid.rerun
      Platformer::Composers::Migrations::Associations::HasMany.rerun

      local_table = Platformer::Databases.server(:postgres, :primary).default_database.structure.configured_schema(:public).table(:foos)

      raise "todo"
    end
  end
end
