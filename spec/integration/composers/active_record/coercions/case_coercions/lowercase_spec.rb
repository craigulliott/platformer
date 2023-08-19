# frozen_string_literal: true

require "spec_helper"

RSpec.describe Platformer::Composers::ActiveRecord::Coercions::CaseCoercions do
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
        add_column :foo, :varchar
      end

      # create a definition for a new User
      create_class "Users::UserModel", TestBaseModel do
        text_field :foo do
          lowercase
        end
      end

      # now that the UserModel has been created, we rerun the relevant composers
      Platformer::Composers::ActiveRecord::CreateActiveModels.rerun
      Platformer::Composers::ActiveRecord::Coercions::CaseCoercions.rerun
    end

    after(:each) do
      destroy_class Users::User
    end

    it "automatically lowercases values when creating" do
      user = Users::User.create! foo: "ABC"
      expect(user.foo).to eql "abc"
      user.reload
      expect(user.foo).to eql "abc"
    end

    it "automatically lowercases values when updating" do
      user = Users::User.create! foo: "ABC"
      user.update(foo: "DEF")
      expect(user.foo).to eql "def"
      user.reload
      expect(user.foo).to eql "def"
    end

    it "automatically lowercases values when updating and skipping validations" do
      user = Users::User.create! foo: "ABC"
      user.update_attribute(:foo, "DEF")
      expect(user.foo).to eql "def"
      user.reload
      expect(user.foo).to eql "def"
    end

    it "ignores nil values without raising an error" do
      user = Users::User.create! foo: nil
      expect(user.foo).to be nil
      user.reload
      expect(user.foo).to be nil
    end
  end

  describe "for a new UserModel which defines a simple new model with an array of chars field and immutable validation" do
    before(:each) do
      pg_helper.create_model :public, :users do
        add_column :foo, :"varchar[]"
      end

      # create a definition for a new User
      create_class "Users::UserModel", TestBaseModel do
        text_field :foo do
          lowercase
        end
      end

      # now that the UserModel has been created, we rerun the relevant composers
      Platformer::Composers::ActiveRecord::CreateActiveModels.rerun
      Platformer::Composers::ActiveRecord::Coercions::CaseCoercions.rerun
    end

    after(:each) do
      destroy_class Users::User
    end

    it "automatically lowercases values when creating" do
      user = Users::User.create! foo: ["ABC"]
      expect(user.foo).to eql ["abc"]
      user.reload
      expect(user.foo).to eql ["abc"]
    end

    it "automatically lowercases values when updating" do
      user = Users::User.create! foo: ["ABC"]
      user.update(foo: ["DEF"])
      expect(user.foo).to eql ["def"]
      user.reload
      expect(user.foo).to eql ["def"]
    end

    it "automatically lowercases values when updating and skipping validations" do
      user = Users::User.create! foo: ["ABC"]
      user.update_attribute(:foo, ["DEF"])
      expect(user.foo).to eql ["def"]
      user.reload
      expect(user.foo).to eql ["def"]
    end

    it "ignores nil values without raising an error" do
      user = Users::User.create! foo: nil
      expect(user.foo).to be nil
      user.reload
      expect(user.foo).to be nil
    end
  end
end
