# frozen_string_literal: true

require "spec_helper"

RSpec.describe Platformer::Composers::ActiveRecord::Validations::Common::Strings do
  describe "for a new UserModel which defines a simple new model with string fields and string validations" do
    before(:each) do
      scaffold do
        table_for "Users::User" do
          add_column :my_char, :char
          add_column :my_text, :text
          add_column :my_second_char, :char
          add_column :my_second_text, :text
          add_column :my_third_char, :char
          add_column :my_third_text, :text
          add_column :my_fourth_char, :char
        end

        model_for "Users::User" do
          database :postgres, :primary
          schema :users

          char_field :my_char do
            allow_null
            validate_minimum_length 3, message: "invalid my_char"
          end
          text_field :my_text do
            allow_null
            validate_maximum_length 5, message: "invalid my_text"
          end
          char_field :my_second_char do
            allow_null
            validate_length_is 10, message: "invalid my_second_char"
          end
          text_field :my_second_text do
            allow_null
            validate_format(/[a-z]+/, message: "invalid my_second_text")
          end
          char_field :my_third_char do
            allow_null
            validate_in ["foo", "bar"], message: "invalid my_third_char"
          end
          text_field :my_third_text do
            allow_null
            validate_not_in ["foo", "bar"], message: "invalid my_third_text"
          end
          char_field :my_fourth_char do
            allow_null
            validate_is_value "exact_value", message: "invalid my_fourth_char"
          end
        end
      end
    end

    let(:user) {
      Users::User.new(
        my_char: "abcd",
        my_text: "abcd",
        my_second_char: "abcdefghij",
        my_second_text: "foo",
        my_third_char: "foo",
        my_third_text: "not_foo",
        my_fourth_char: "exact_value"
      )
    }

    it "validates as true when the values are permitted" do
      expect(user.valid?).to be true
    end

    it "allows null values" do
      user.my_char = nil
      user.my_text = nil
      user.my_second_char = nil
      user.my_second_text = nil
      user.my_third_char = nil
      user.my_third_text = nil
      user.my_fourth_char = nil

      expect(user.valid?).to be true
    end

    it "validates as false when the validate_minimum_length is violated" do
      user.my_char = "a"
      expect(user.valid?).to be false
      expect(user.errors.map(&:message)).to eql ["invalid my_char"]
    end

    it "validates as false when the validate_maximum_length is violated" do
      user.my_text = "this string is too long"
      expect(user.valid?).to be false
      expect(user.errors.map(&:message)).to eql ["invalid my_text"]
    end

    it "validates as false when the validate_length_is is violated" do
      user.my_second_char = "aaa"
      expect(user.valid?).to be false
      expect(user.errors.map(&:message)).to eql ["invalid my_second_char"]
    end

    it "validates as false when the validate_format is violated" do
      user.my_second_text = "ABC"
      expect(user.valid?).to be false
      expect(user.errors.map(&:message)).to eql ["invalid my_second_text"]
    end

    it "validates as false when the validate_in is violated" do
      user.my_third_char = "a"
      expect(user.valid?).to be false
      expect(user.errors.map(&:message)).to eql ["invalid my_third_char"]
    end

    it "validates as false when the validate_not_in is violated" do
      user.my_third_text = "foo"
      expect(user.valid?).to be false
      expect(user.errors.map(&:message)).to eql ["invalid my_third_text"]
    end

    it "validates as false when the validate_is_value is violated" do
      user.my_fourth_char = "a"
      expect(user.valid?).to be false
      expect(user.errors.map(&:message)).to eql ["invalid my_fourth_char"]
    end
  end
end
