# frozen_string_literal: true

require "spec_helper"

RSpec.describe Platformer::Composers::ActiveRecord::Validations::Common::Immutable do
  describe "for a new UserModel which defines a simple new model with an integer field and immutable validation" do
    before(:each) do
      scaffold do
        table_for "Users::User" do
          add_column :foo, :integer
        end

        # create a definition for a new User
        model_for "Users::User" do
          database :postgres, :primary
          schema :users
          integer_field :foo do
            allow_null
            immutable_once_set
          end
        end
      end
    end

    it "has the expected immutable_once_set_validator" do
      immutable_once_set_validator = Users::User.validators.find { |v| v.instance_of? ImmutableOnceSetValidator }

      expect(immutable_once_set_validator).to_not be_nil
      expect(immutable_once_set_validator.attributes).to eql([:foo])
    end

    it "has a immutable_once_set_validator which fails when expected" do
      user = Users::User.create! foo: 123
      user.foo = 456
      expect(user.valid?).to be false
    end
  end
end
