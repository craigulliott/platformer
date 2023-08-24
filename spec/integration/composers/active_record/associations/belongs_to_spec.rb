# frozen_string_literal: true

require "spec_helper"

RSpec.describe Platformer::Composers::ActiveRecord::Associations::BelongsTo do
  let(:pg_helper) { RSpec.configuration.pg_spec_helper }

  before(:each) do
    create_class :TestBaseModel, PlatformModel do
      database :postgres, :primary
    end
  end

  after(:each) do
    destroy_class TestBase
  end

  describe "for a new BadgeModel which belongs to a UserModel" do
    before(:each) do
      pg_helper.create_model :public, :users
      pg_helper.create_model :public, :badges do
        add_column :user_id, :uuid
      end

      create_class "UserModel", TestBaseModel do
        uuid_field :id
      end
      create_class "BadgeModel", TestBaseModel do
        uuid_field :id
        belongs_to "UserModel"
      end

      # now that the UserModel has been created, we rerun the relevant composers
      Platformer::Composers::ActiveRecord::CreateActiveModels.rerun
      Platformer::Composers::ActiveRecord::Associations::BelongsTo.rerun
    end

    after(:each) do
      destroy_class User
      destroy_class Badge
    end

    it "adds the expected association to the Badge class" do
      user = User.create
      badge = Badge.create user_id: user.id
      badge.reload

      expect(badge.user).to eq user
    end
  end
end
