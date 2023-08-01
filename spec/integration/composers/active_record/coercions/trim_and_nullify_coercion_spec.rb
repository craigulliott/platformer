# frozen_string_literal: true

require "spec_helper"

RSpec.describe Platformer::Composers::ActiveRecord::Coercions::TrimAndNullifyCoercions do
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
          trim_and_nullify
        end
      end

      # now that the UserModel has been created, we rerun the relevant composers
      Platformer::Composers::ActiveRecord::CreateActiveModels.rerun
      Platformer::Composers::ActiveRecord::Coercions::TrimAndNullifyCoercions.rerun
    end

    after(:each) do
      destroy_class Users::User
    end

    it "automatically trims values when creating" do
      user = Users::User.create! foo: " abc "
      expect(user.foo).to eq "abc"
      user.reload
      expect(user.foo).to eq "abc"
    end

    it "automatically trims values when updating" do
      user = Users::User.create! foo: " abc "
      user.update(foo: " def ")
      expect(user.foo).to eq "def"
      user.reload
      expect(user.foo).to eq "def"
    end

    it "automatically trims values when updating and skipping validations" do
      user = Users::User.create! foo: " abc "
      user.update_attribute(:foo, " def ")
      expect(user.foo).to eq "def"
      user.reload
      expect(user.foo).to eq "def"
    end

    it "automatically converts an empty string to nil when creating" do
      user = Users::User.create! foo: ""
      expect(user.foo).to eq nil
      user.reload
      expect(user.foo).to eq nil
    end

    it "automatically converts an empty string to nil when updating" do
      user = Users::User.create! foo: "abc"
      user.update(foo: "")
      expect(user.foo).to eq nil
      user.reload
      expect(user.foo).to eq nil
    end

    it "automatically converts an empty string to nil when updating and skipping validations" do
      user = Users::User.create! foo: "abc"
      user.update_attribute(:foo, "")
      expect(user.foo).to eq nil
      user.reload
      expect(user.foo).to eq nil
    end

    it "automatically converts a string containing only whitespace to nil when creating" do
      user = Users::User.create! foo: "  "
      expect(user.foo).to eq nil
      user.reload
      expect(user.foo).to eq nil
    end

    it "automatically converts a string containing only whitespace to nil when updating" do
      user = Users::User.create! foo: "abc"
      user.update(foo: "  ")
      expect(user.foo).to eq nil
      user.reload
      expect(user.foo).to eq nil
    end

    it "automatically converts a string containing only whitespace to nil when updating and skipping validations" do
      user = Users::User.create! foo: "abc"
      user.update_attribute(:foo, "  ")
      expect(user.foo).to eq nil
      user.reload
      expect(user.foo).to eq nil
    end

    it "ignores nil values without raising an error" do
      user = Users::User.create! foo: nil
      expect(user.foo).to be nil
      user.reload
      expect(user.foo).to be nil
    end
  end
end
