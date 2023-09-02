# frozen_string_literal: true

require "spec_helper"

RSpec.describe Platformer::Composers::ActiveRecord::Validations::Fields::Enum do
  describe "for a new UserModel which defines a simple new model with a enum field" do
    before(:each) do
      pg_helper.create_enum :public, :enum_values, ["foo", "bar"]
      scaffold do
        table_for "Users::User" do
          add_column :my_enum, :enum_values
        end

        # create a definition for a new User
        model_for "Users::User" do
          database :postgres, :primary
          schema :users

          enum_field :my_enum, ["foo", "bar"]
        end
      end
    end

    it "has the expected default inclusion validator which all enum fields have" do
      inclusion_validators = Users::User.validators.filter { |v| v.instance_of? ActiveModel::Validations::InclusionValidator }

      # the first validator is the default which is applied to all enum fields
      expect(inclusion_validators.first.options).to eql({
        allow_nil: false,
        in: ["foo", "bar"]
      })
    end

    it "has a inclusion_validator which fails when expected" do
      user = Users::User.new my_enum: :unexpected

      expect(user.valid?).to be false
    end

    it "has a inclusion_validator which succeeds when expected" do
      user = Users::User.new my_enum: "foo"

      expect(user.valid?).to be true
    end
  end
end
