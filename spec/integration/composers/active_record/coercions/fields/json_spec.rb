# frozen_string_literal: true

require "spec_helper"

RSpec.describe Platformer::Composers::ActiveRecord::Coercions::Fields::Json do
  describe "for a new UserModel which defines a simple new model with a json field and a empty_json_to_null coercion" do
    before(:each) do
      scaffold do
        table_for "Users::User" do
          add_column :my_json, :json
        end

        # create a definition for a new User
        model_for "Users::User" do
          database :postgres, :primary
          schema :users

          json_field :my_json, allow_null: true do
            empty_json_to_null
          end
        end
      end
    end

    it "automatically converts an empty object to nil when creating" do
      user = Users::User.create! my_json: {}
      expect(user.my_json).to eq nil
      user.reload
      expect(user.my_json).to eq nil
    end

    it "automatically converts an empty object to nil when updating" do
      user = Users::User.create! my_json: 123
      user.update(my_json: {})
      expect(user.my_json).to eq nil
      user.reload
      expect(user.my_json).to eq nil
    end

    it "automatically converts an empty object to nil when updating and skipping validations" do
      user = Users::User.create! my_json: 123
      user.update_attribute(:my_json, {})
      expect(user.my_json).to eq nil
      user.reload
      expect(user.my_json).to eq nil
    end

    it "does not change numbers other than an empty object when creating" do
      user = Users::User.create! my_json: 123
      expect(user.my_json).to eq 123
      user.reload
      expect(user.my_json).to eq 123
    end

    it "does not change numbers other than an empty object when updating" do
      user = Users::User.create! my_json: 123
      user.update(my_json: 456)
      expect(user.my_json).to eq 456
      user.reload
      expect(user.my_json).to eq 456
    end

    it "does not change numbers other than an empty object when updating and skipping validations" do
      user = Users::User.create! my_json: 123
      user.update_attribute(:my_json, 456)
      expect(user.my_json).to eq 456
      user.reload
      expect(user.my_json).to eq 456
    end

    it "ignores nil values without raising an error" do
      user = Users::User.create! my_json: nil
      expect(user.my_json).to be nil
      user.reload
      expect(user.my_json).to be nil
    end
  end
end
