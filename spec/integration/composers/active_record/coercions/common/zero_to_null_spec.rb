# frozen_string_literal: true

require "spec_helper"

RSpec.describe Platformer::Composers::ActiveRecord::Coercions::Common::ZeroToNull do
  describe "for a new UserModel which defines a simple new model with an char field and zero to null coercion" do
    before(:each) do
      scaffold do
        table_for "Users::User" do
          add_column :foo, :integer
        end
        model_for "Users::User" do
          database :postgres, :primary
          schema :users
          integer_field :foo do
            zero_to_null
            allow_null
          end
        end
      end
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

  describe "for a new UserModel which defines a simple new model with an array of chars field and zero to null coercion" do
    before(:each) do
      scaffold do
        table_for "Users::User" do
          add_column :foo, :"integer[]"
        end
        model_for "Users::User" do
          database :postgres, :primary
          schema :users
          integer_field :foo, array: true do
            zero_to_null
            allow_null
          end
        end
      end
    end

    it "automatically converts 0 to nil when creating" do
      user = Users::User.create! foo: [0, 1]
      expect(user.foo).to eq [nil, 1]
      user.reload
      expect(user.foo).to eq [nil, 1]
    end

    it "automatically converts 0 to nil when updating" do
      user = Users::User.create! foo: [1, 2]
      user.update(foo: [3, 0])
      expect(user.foo).to eq [3, nil]
      user.reload
      expect(user.foo).to eq [3, nil]
    end

    it "automatically converts 0 to nil when updating and skipping validations" do
      user = Users::User.create! foo: [1, 2]
      user.update_attribute(:foo, [3, 0])
      expect(user.foo).to eq [3, nil]
      user.reload
      expect(user.foo).to eq [3, nil]
    end

    it "ignores nil values without raising an error" do
      user = Users::User.create! foo: nil
      expect(user.foo).to be nil
      user.reload
      expect(user.foo).to be nil
    end
  end
end
