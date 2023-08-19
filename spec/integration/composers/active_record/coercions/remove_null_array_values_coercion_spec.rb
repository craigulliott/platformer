# frozen_string_literal: true

require "spec_helper"

RSpec.describe Platformer::Composers::ActiveRecord::Coercions::RemoveNullArrayValuesCoercions do
  let(:pg_helper) { RSpec.configuration.pg_spec_helper }

  before(:each) do
    create_class :TestBaseModel, PlatformModel do
      database :postgres, :primary
    end
  end

  after(:each) do
    destroy_class TestBase
  end

  describe "for a new UserModel which defines a simple new model with an array of chars field and trim and nullify coercion" do
    before(:each) do
      pg_helper.create_model :public, :users do
        add_column :foo, :"varchar[]"
      end

      # create a definition for a new User
      create_class "Users::UserModel", TestBaseModel do
        text_field :foo, array: true do
          remove_null_array_values
        end
      end

      # now that the UserModel has been created, we rerun the relevant composers
      Platformer::Composers::ActiveRecord::CreateActiveModels.rerun
      Platformer::Composers::ActiveRecord::Coercions::RemoveNullArrayValuesCoercions.rerun
    end

    after(:each) do
      destroy_class Users::User
    end

    it "automatically removes nil array values when creating" do
      user = Users::User.create! foo: ["abc", nil, "foo"]
      expect(user.foo).to eq ["abc", "foo"]
      user.reload
      expect(user.foo).to eq ["abc", "foo"]
    end

    it "automatically removes nil array values when updating" do
      user = Users::User.create! foo: ["abc", "foo"]
      user.update(foo: ["def", nil, "baz"])
      expect(user.foo).to eq ["def", "baz"]
      user.reload
      expect(user.foo).to eq ["def", "baz"]
    end

    it "automatically removes nil array values when updating and skipping validations" do
      user = Users::User.create! foo: ["abc", "foo"]
      user.update_attribute(:foo, ["def", nil, "baz"])
      expect(user.foo).to eq ["def", "baz"]
      user.reload
      expect(user.foo).to eq ["def", "baz"]
    end

    it "ignores nil values without raising an error" do
      user = Users::User.create! foo: nil
      expect(user.foo).to be nil
      user.reload
      expect(user.foo).to be nil
    end
  end
end
