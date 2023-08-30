# frozen_string_literal: true

require "spec_helper"

RSpec.describe Platformer::Composers::ActiveRecord::Associations::HasMany do
  let(:pg_helper) { RSpec.configuration.pg_spec_helper }

  before(:each) do
    create_class :TestBaseModel, Platformer::BaseModel do
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
        has_many "BadgeModel"
      end
      create_class "BadgeModel", TestBaseModel do
        uuid_field :id
      end

      # now that the UserModel has been created, we rerun the relevant composers
      Platformer::Composers::ActiveRecord::CreateActiveModels.rerun
      Platformer::Composers::ActiveRecord::Associations::HasMany.rerun
    end

    after(:each) do
      destroy_class User
      destroy_class Badge
    end

    it "adds the expected association to the Badge class" do
      user = User.create
      badge = user.badges.create!
      user.reload

      expect(user.badges.map(&:id)).to eql [badge.id]
    end
  end
end
