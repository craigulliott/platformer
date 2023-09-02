# frozen_string_literal: true

require "spec_helper"

RSpec.describe Platformer::Composers::ActiveRecord::Validations::Common::NotNull do
  describe "for a new UserModel which defines a simple new model with char fields, one of which is nullable" do
    before(:each) do
      scaffold do
        table_for "Users::User" do
          add_column :my_char, :char
          add_column :my_nullable_char, :char, null: true
        end

        # create a definition for a new User
        model_for "Users::User" do
          database :postgres, :primary
          schema :users
          char_field :my_char do
          end
          char_field :my_nullable_char do
            allow_null
          end
        end
      end
    end

    let(:user) {
      Users::User.new(
        my_char: "foo",
        my_nullable_char: "foo"
      )
    }

    it "validates as true when the values are permitted" do
      expect(user.valid?).to be true
    end

    it "allows null values in nullable fields" do
      user.my_nullable_char = nil
      expect(user.valid?).to be true
    end

    it "validates as false when null values are placed in non nullable fields" do
      user.my_char = nil
      expect(user.valid?).to be false
    end
  end
end
