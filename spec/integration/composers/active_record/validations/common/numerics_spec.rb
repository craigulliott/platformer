# frozen_string_literal: true

require "spec_helper"

RSpec.describe Platformer::Composers::ActiveRecord::Validations::Common::Numerics do
  describe "for a new UserModel which defines a simple new model with numeric fields and numeric validations" do
    before(:each) do
      scaffold do
        table_for "Users::User" do
          add_column :my_integer, :integer, null: true
          add_column :my_float, :float, null: true
          add_column :my_numeric, :"numeric(10,2)", null: true
          add_column :my_double, :"double precision", null: true
          add_column :my_other_double, :"double precision", null: true
        end

        model_for "Users::User" do
          database :postgres, :primary
          schema :users

          integer_field :my_integer do
            allow_null
            validate_greater_than 0, message: "invalid my_integer"
          end
          float_field :my_float do
            allow_null
            validate_greater_than_or_equal_to 0, message: "invalid my_float"
          end
          numeric_field :my_numeric do
            allow_null
            validate_less_than 10, message: "invalid my_numeric"
          end
          numeric_field :my_double do
            allow_null
            validate_less_than_or_equal_to 10, message: "invalid my_double"
          end
          numeric_field :my_other_double do
            allow_null
            validate_equal_to 8, message: "invalid my_other_double"
          end
        end
      end
    end

    let(:user) {
      Users::User.new(
        my_integer: 1,
        my_float: 0,
        my_numeric: 5,
        my_double: 10,
        my_other_double: 8
      )
    }

    it "validates as true when the values are permitted" do
      expect(user.valid?).to be true
    end

    it "allows null values" do
      user.my_integer = nil
      user.my_float = nil
      user.my_numeric = nil
      user.my_double = nil
      user.my_other_double = nil

      expect(user.valid?).to be true
    end

    it "validates as false when the validate_greater_than is violated" do
      user.my_integer = -1
      expect(user.valid?).to be false
      expect(user.errors.map(&:message)).to eql ["invalid my_integer"]
    end

    it "validates as false when the validate_greater_than_or_equal_to is violated" do
      user.my_float = -1
      expect(user.valid?).to be false
      expect(user.errors.map(&:message)).to eql ["invalid my_float"]
    end

    it "validates as false when the validate_less_than is violated" do
      user.my_numeric = 11
      expect(user.valid?).to be false
      expect(user.errors.map(&:message)).to eql ["invalid my_numeric"]
    end

    it "validates as false when the validate_less_than_or_equal_to is violated" do
      user.my_double = 11
      expect(user.valid?).to be false
      expect(user.errors.map(&:message)).to eql ["invalid my_double"]
    end

    it "validates as false when the validate_equal_to is violated" do
      user.my_other_double = 11
      expect(user.valid?).to be false
      expect(user.errors.map(&:message)).to eql ["invalid my_other_double"]
    end
  end
end
