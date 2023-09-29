# frozen_string_literal: true

require "spec_helper"

RSpec.describe Platformer::Composers::ActiveRecord::Coercions::Common::EmptyArrayToNull do
  describe "for a new UserModel which defines a simple new model with an array of chars field and trim and nullify coercion" do
    before(:each) do
      scaffold do
        table_for "Users::User" do
          add_column :foo, :"varchar[]"
        end

        model_for "Users::User" do
          database :postgres, :primary
          schema :users
          text_field :foo, array: true, allow_null: true do
            empty_array_to_null
          end
        end
      end
    end

    it "accepts an array of values when creating" do
      user = Users::User.create! foo: ["a", "b"]
      expect(user.foo).to eql ["a", "b"]
      user.reload
      expect(user.foo).to eql ["a", "b"]
    end

    it "accepts an array of values when updating" do
      user = Users::User.create! foo: ["a", "b"]
      user.update(foo: ["c", "d"])
      expect(user.foo).to eq ["c", "d"]
      user.reload
      expect(user.foo).to eq ["c", "d"]
    end

    it "accepts an array of values when updating and skipping validations" do
      user = Users::User.create! foo: ["a", "b"]
      user.update_attribute(:foo, ["c", "d"])
      expect(user.foo).to eq ["c", "d"]
      user.reload
      expect(user.foo).to eq ["c", "d"]
    end

    it "automatically converts an empty array to nil when creating" do
      user = Users::User.create! foo: []
      expect(user.foo).to eq nil
      user.reload
      expect(user.foo).to eq nil
    end

    it "automatically converts an empty array to nil when updating" do
      user = Users::User.create! foo: ["a", "b"]
      user.update(foo: [])
      expect(user.foo).to eq nil
      user.reload
      expect(user.foo).to eq nil
    end

    it "automatically converts an empty array to nil when updating and skipping validations" do
      user = Users::User.create! foo: ["a", "b"]
      user.update_attribute(:foo, [])
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
