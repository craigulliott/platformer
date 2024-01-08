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
          text_field :foo, allow_null: true do
            uppercase
          end
        end
      end
    end

    it "automatically uppercases values when creating" do
      user = Users::User.create! foo: "abc"
      expect(user.foo).to eq "ABC"
      user.reload
      expect(user.foo).to eq "ABC"
    end

    it "automatically uppercases values when updating" do
      user = Users::User.create! foo: "abc"
      user.update(foo: "def")
      expect(user.foo).to eq "DEF"
      user.reload
      expect(user.foo).to eq "DEF"
    end

    it "automatically uppercases values when updating and skipping validations" do
      user = Users::User.create! foo: "abc"
      user.update_attribute(:foo, "def")
      expect(user.foo).to eq "DEF"
      user.reload
      expect(user.foo).to eq "DEF"
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
          text_field :foo, array: true, allow_null: true do
            uppercase
          end
        end
      end
    end

    it "automatically uppercases values when creating" do
      user = Users::User.create! foo: ["abc"]
      expect(user.foo).to eql ["ABC"]
      user.reload
      expect(user.foo).to eql ["ABC"]
    end

    it "automatically uppercases values when updating" do
      user = Users::User.create! foo: ["abc"]
      user.update(foo: ["def"])
      expect(user.foo).to eql ["DEF"]
      user.reload
      expect(user.foo).to eql ["DEF"]
    end

    it "automatically uppercases values when updating and skipping validations" do
      user = Users::User.create! foo: ["abc"]
      user.update_attribute(:foo, ["def"])
      expect(user.foo).to eql ["DEF"]
      user.reload
      expect(user.foo).to eql ["DEF"]
    end

    it "ignores nil values without raising an error" do
      user = Users::User.create! foo: nil
      expect(user.foo).to be nil
      user.reload
      expect(user.foo).to be nil
    end
  end
end
