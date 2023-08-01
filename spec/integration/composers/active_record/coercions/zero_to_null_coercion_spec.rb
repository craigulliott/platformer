# frozen_string_literal: true

require "spec_helper"

RSpec.describe Platformer::Composers::ActiveRecord::Coercions::ZeroToNullCoercions do
  let(:pg_helper) { RSpec.configuration.pg_spec_helper }

  before(:each) do
    create_class :TestBaseModel, PlatformModel do
      database :postgres, :primary
    end
  end

  after(:each) do
    destroy_class TestBase
  end

  describe "for a new UserModel which defines a simple new model with an char field and immutable validation" do
    before(:each) do
      pg_helper.create_model :public, :users do
        add_column :foo, :integer
      end

      # create a definition for a new User
      create_class "Users::UserModel", TestBaseModel do
        integer_field :foo do
          zero_to_null
        end
      end

      # now that the UserModel has been created, we rerun the relevant composers
      Platformer::Composers::ActiveRecord::CreateActiveModels.rerun
      Platformer::Composers::ActiveRecord::Coercions::ZeroToNullCoercions.rerun
    end

    after(:each) do
      destroy_class Users::User
    end

    it "automatically converts 0 to nil when creating" do
      user = Users::User.create! foo: 0
      expect(user.foo).to eq nil
      user.reload
      expect(user.foo).to eq nil
    end

    it "automatically converts 0 to nil when updating" do
      user = Users::User.create! foo: 123
      user.update(foo: 0)
      expect(user.foo).to eq nil
      user.reload
      expect(user.foo).to eq nil
    end

    it "automatically converts 0 to nil when updating and skipping validations" do
      user = Users::User.create! foo: 123
      user.update_attribute(:foo, 0)
      expect(user.foo).to eq nil
      user.reload
      expect(user.foo).to eq nil
    end

    it "does not change numbers other than 0 when creating" do
      user = Users::User.create! foo: 123
      expect(user.foo).to eq 123
      user.reload
      expect(user.foo).to eq 123
    end

    it "does not change numbers other than 0 when updating" do
      user = Users::User.create! foo: 123
      user.update(foo: 456)
      expect(user.foo).to eq 456
      user.reload
      expect(user.foo).to eq 456
    end

    it "does not change numbers other than 0 when updating and skipping validations" do
      user = Users::User.create! foo: 123
      user.update_attribute(:foo, 456)
      expect(user.foo).to eq 456
      user.reload
      expect(user.foo).to eq 456
    end

    it "ignores nil values without raising an error" do
      user = Users::User.create! foo: nil
      expect(user.foo).to be nil
      user.reload
      expect(user.foo).to be nil
    end
  end
end
