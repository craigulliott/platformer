# frozen_string_literal: true

require "spec_helper"

RSpec.describe Platformer::Composers::ActiveRecord::Coercions::Common::Case do

  describe "for a new UserModel which defines a simple new model with an char field and immutable validation" do
    before(:each) do
      scaffold do
        table_for "Users::User" do
          add_column :foo, :varchar
        end

        model_for "Users::User" do
          database :postgres, :primary
          schema :users
          text_field :foo do
            lowercase
            allow_null
          end
        end
      end
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
      scaffold do
        table_for "Users::User" do
          add_column :foo, :"varchar[]"
        end

        model_for "Users::User" do
          database :postgres, :primary
          schema :users
          text_field :foo, array: true do
            lowercase
            allow_null
          end
        end
      end
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
